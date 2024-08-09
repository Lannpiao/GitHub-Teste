// INICIANDO VARIÁVEIS
sel				= 0; // valor selecionado no menu
menu_pagina		= 0; // Variável responável por qual menu mostrar
_sair			= noone


#region //MÉTODOS DO MENU
teclado			= function(_menu)// SELECIONANDO MENU PELO TECLADO
{
	var  _cima, _baixo, _menu_comprimento, _esquer, _direta;
	_cima							= keyboard_check_pressed(vk_up); // checando se eu apertei a tecla UP do teclado
	_baixo							= keyboard_check_pressed(vk_down); // checando se eu apertei a tecla DOWN do teclado
	_esquer							= keyboard_check_pressed(vk_left); // checando se eu apertei a tecla DOWN do teclado
	_direta							= keyboard_check_pressed(vk_right); // checando se eu apertei a tecla DOWN do teclado
	_menu_comprimento				= array_length(_menu);
	var _confirma					= keyboard_check_pressed(vk_enter); // confirmar a opção desejada do menu
	var _sel						= menus_sel[menu_pagina];
	
	if(!menu_interno) // só consigo selecionar menu vertical caso eu não esteja em um menu lateral
	{
		if(_baixo or _cima) 
		{
			menus_sel[menu_pagina] += _baixo - _cima; // MOVENDO SELEÇÃO PARA CIMA PI BAIXO
			menus_sel[menu_pagina] = clamp(menus_sel[menu_pagina], 0, _menu_comprimento -1) // limitando o valor para n ultrapassar o valor máximo ou mínimo no menu
		}
	}
	else // controlando menu interno (menu horizontal)
	{
		if(_esquer or _direta)
		{
			var _menu_int_limit		= array_length(_menu[_sel][4]) -1;
			menus[menu_pagina][_sel][3] += _direta - _esquer; // alterando o valor do menu interno
			menus[menu_pagina][_sel][3] = clamp(menus[menu_pagina][_sel][3], 0, _menu_int_limit); // limitando o valor para n ultrapassar o valor máximo ou mínimo no menu interno
		}
		
	}
	if(_confirma)// confirmando opção selecionada
	{

		switch(_menu[_sel][1]) // checa qual opção estou selecionado e pega a acção dessa opção
		{
			case MENU_ACAO.CHAMA_METODO: _menu[_sel][2](); _sel = 0; break;  // chamando método 
			case MENU_ACAO.CHAMA_MENU: menu_pagina = _menu[_sel][2]; _sel = 0; break; // chamando novo menu
			case MENU_ACAO.CHAMA_AJUSTES: 
			{
				menu_interno = !menu_interno;  // alterando entre menu horizontal e vertical
				if(!menu_interno)
				{
					var _argumento = _menu[_sel][3];
					_menu[_sel][2](_argumento); // chamando função do menu interno
				}
				break;
			}
		}
	}
	
	
	
	
}



// Escrevendo o Menu na tela
criar_menu		= function(_menu)
{
	
	draw_set_font(fnt_menu) // definindo a font a ser utilizada

	var _menu_comprimento	= array_length(_menu); // Pegando a quantidade de opções no menu
	var _menu_pos_x			= display_get_gui_width()/2; // Posição X do menu 
	var _menu_pos_y			= display_get_gui_height()/2; // Posição Y do menu
	var _mouse_pos_x		= device_mouse_x_to_gui(0) // pegando posição x do moouse na tela
	var _mouse_pos_y		= device_mouse_y_to_gui(0)  // pegando posição y do moouse na tela
	var _texto_altu			= string_height("I") + 10; // Altura do texto + uma margem 
	var _menu_altu			= (_texto_altu * _menu_comprimento) / 2; // Posição central do menu
	var _cor				= c_white; // cor do menu nas opções não selecionado
	var _cor2				= c_white; // cor do menu nas opções não selecionado
	var _confirma			= mouse_check_button_pressed(mb_left); // confirmar a opção desejada do menu
	

	
	for(var i = 0; i < _menu_comprimento; i++)
	{
		
		var _text_option	= _menu[i][0] // peganod os valores de menu
		var _texto_larg			= string_width(_text_option)
		var _pos_tela_mouse		= point_in_rectangle(_mouse_pos_x, _mouse_pos_y, _menu_pos_x - 1 - _texto_larg/2, _menu_pos_y + _menu_altu + (i * _texto_altu), _menu_pos_x + _texto_larg/2, _menu_pos_y + _menu_altu + (i * _texto_altu) + _texto_altu -10)
		// SELECIONANDO OPÇÃO

		if(menus_sel[menu_pagina] == i)
		{
			_cor			= c_red // resetando a cor nas opções não selecionada
			
		}
		else 
		{
			_cor			= c_white; // cor do menu na opção selecionado
			
		}
		
		if(_pos_tela_mouse)
		{
			if(!menu_interno)
			{
				menus_sel[menu_pagina] = i
			}
			if(_confirma)
			{
				//if(menus_sel[menu_pagina] == MENU_ACAO.CHAMA_METODO) _menu[i][2]()
				switch(_menu[i][1]) // checa qual opção estou selecionado e pega a acção dessa opção
				{
					case MENU_ACAO.CHAMA_METODO: _menu[i][2](); break;  // chamando método 
					case MENU_ACAO.CHAMA_MENU: menu_pagina = _menu[i][2]; break; // chamando novo menu
					case MENU_ACAO.CHAMA_AJUSTES: 
					{
						menu_interno = !menu_interno;  // alterando entre menu horizontal e vertical
						if(!menu_interno)
						{
							var _argumento = _menu[i][3];
							_menu[i][2](_argumento); // chamando função do menu interno
							
						}
						break;
					}
				}
			}
		}
		
		
		
		
		draw_set_halign(fa_center) // alinhando texto ao centro da tela

		draw_text_color(_menu_pos_x, _menu_pos_y + _menu_altu + (i * _texto_altu), _text_option, _cor, _cor, _cor, _cor, image_alpha) // desenhando menu PRINCIPAL
	
	}
	
	// criando os menus internos quando existir
	for(var i = 0; i < _menu_comprimento; i++)
	{
		switch(_menu[i][1])
		{
			case MENU_ACAO.CHAMA_AJUSTES:
			{
				// SALVANDO ÍNDICE
				var _indece				= _menu[i][3]; // pegando o valor do indece no menu para alterar o menu interno
				var _texto_menu_int		= _menu[i][4][_indece]; //pegando os textos do menu interno
				var _texto_esquerda		= _indece > 0 ? "<< " : ""; 
				var _texto_direita		= _indece < array_length(_menu[i][4]) - 1 ? " >>" : "";
				var _cor_menu_int		= c_white;
				var _texto_larg			= string_width("DESATIVADO") + 20
				if (menu_interno && menus_sel[menu_pagina] == i) 
				{
					_cor_menu_int = c_red; // mudando a cor do menu interno
					
					virtual_key_add(_menu_pos_x + 200, _menu_pos_y + _menu_altu, 32, _menu_pos_y + _menu_altu + 32, vk_left) // tecla virtual para altera o menu interno simulando a tecla left
					virtual_key_add(_menu_pos_x + 200 + _texto_larg, _menu_pos_y + _menu_altu, 32, _menu_pos_y + _menu_altu + 32, vk_right) // tecla virtual para altera o menu interno simulando a tecla right
					draw_rectangle(_menu_pos_x + 200, _menu_pos_y + _menu_altu + (i * _texto_altu), _menu_pos_x + 200 + 32, _menu_pos_y + _menu_altu + 32 + (i * _texto_altu), false)
					draw_rectangle(_menu_pos_x + 200 + _texto_larg, _menu_pos_y + _menu_altu + (i * _texto_altu), _menu_pos_x + 200 + 32 + _texto_larg, _menu_pos_y + _menu_altu + 32 + (i * _texto_altu), false)
					
				}
				// desenhando menu interno
				draw_text_color(_menu_pos_x + 250 - 5, _menu_pos_y + _menu_altu + (i * _texto_altu), _texto_menu_int, c_black, c_black, c_black, c_black, image_alpha)
				draw_text_color(_menu_pos_x + 250, _menu_pos_y + _menu_altu + (i * _texto_altu), _texto_menu_int, _cor_menu_int, _cor_menu_int, _cor_menu_int, _cor_menu_int, image_alpha)
				
				
				
				break;	
			}
			
		}
	}
	
	draw_set_font(-1) // restaurando as fontes
	draw_set_halign(-1)	 // restaurando a poisção horizontal
}


iniciar_jogo			= function() // função que inicia o jogo
{
	show_message("jogos")
}

fechar_jogo			= function()
{ 
	game_end() // saindo do jogo caso clico em yes
}

configura_tela		= function(_indece)
{
	switch(_indece)
	{
		case 0: window_set_fullscreen(false); break; // tela em modo janela
		
		case 1: window_set_fullscreen(true); break; // tela em modo tela cheia
	}
}
configura_volume		= function(_indece)
{
	
	//audio_sound_gain(snd_volume_test, _indece/10, 0)
}

#endregion



#region //MENUS
menu_principal		=	[
					//	[OPÇÕES			AÇÃO A SER FEITA			FUNÇÃO OU SUBMENU]
						["JOGOS",		MENU_ACAO.CHAMA_METODO,		iniciar_jogo], // Opção Iniciar do menu, chamamos o metodo para selecionar a opção certa na função cria_menu() e teclado() -- inicia o jogo
					//	["OPTION",		MENU_ACAO.CHAMA_MENU,		MENU_LISTA.MENU_OPCOES], // Opção Opções do menu, chamamos o metodo para selecionar a opção certa na função cria_menu() e teclado() -- chama o menu opções
						["SAIR",		MENU_ACAO.CHAMA_METODO,		fechar_jogo] // Opção Sair do menu, chamamos o metodo para selecionar a opção certa na função cria_menu() e teclado() -- fecha o jogo				
/* 
PARA ADICONAR MAIS OPÇÕES BASATAR CRIAR OUTRO VETOR
["NOME", AÇÃO, FUNÇÃO/MENU]
*/

];
menu_opcoes			=	[
					//	["NOME",		AÇÃO,						FUNÇÃO,						(ÍNDECE INICIAL PARA O MENU INTERNO),		(MENU INTERNO)]
						["VOLUME",		MENU_ACAO.CHAMA_AJUSTES,	configura_volume,			0,											["0", "10", "20", "30", "40", "50", "60", "70", "80", "90", "100"]], // Opção Volume do menu, chamamos o metodo para alterar o volume do jogo
						["SCREEN",		MENU_ACAO.CHAMA_AJUSTES,	configura_tela,				0,											["DESACTIVE", "ACTIVE"]], // Opção Tela do menu, chamamos o metodo para alterar entre tela cheia e modo janela
						["RETURN",		MENU_ACAO.CHAMA_MENU,		MENU_LISTA.MENU_PRINCIPAL] // Opção Sair do menu, chamamos o metodo para voltar para o menu anterior			
/* 
PARA ADICONAR MAIS OPÇÕES BASATAR CRIAR OUTRO VETOR
["NOME", AÇÃO, FUNÇÃO/MENU, (ÍNDECE DO MENU INTERNO), ([OUTRO VETOR CASO EXISTA PARA MENU INTERNO])]
*/
];


menus				= [menu_principal, menu_opcoes] // Organizando todos os menus numa lista


// salvando a seleção de cada menu
menus_sel			= array_create(array_length(menus), 0);
menu_interno		= false; // variável pra checar se estou no menu interno de alguma opção
#endregion