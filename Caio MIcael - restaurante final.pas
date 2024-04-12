//Caio Micael
Program trabalho_avaliativo_1 ;
type
	vet_lista   = array [1..5] of integer;
	
	reg_cliente = record
		clicodigo     : integer;
		nome          : string;
		tipo          : integer;
		valorPedido   : integer;
		tipoPagamento : integer;
	end;
	
	reg_mesas = record
		numeroMesa       : integer;
		cliente_mesa     : reg_cliente;
		isMesaOcupada    : boolean;
	end;
	
	vet_cliente = array [1..10] of reg_cliente;
	vetMesas    = array [1..5] of reg_mesas;
	
	reg_fila = record
		max,posicao   : integer;
		fila_clientes : array [1..10] of reg_cliente;
	end;
	
	reg_prato = record
		max_prato,posicaoPrato : integer;
		A_pratos               : array [1..3] of integer;
	end;
	
	reg_lista = record
		posicaoLista,maxLista,posicaoEscolhido : integer;
		elemento              : integer;
		mesasOcupadas         : array [1..5] of integer;
	end;
	
	reg_fila_tipo = record
		maxTipo,posicaoTipo : integer;
		cliente_tipo        : vet_cliente;
	end;				
	
var i,maxMesas,count,totalCartao,totalDinheiro:integer;
		fila                 : reg_fila;
		cliente              : reg_cliente;
		cadastro_clientes    : vet_cliente;
		pratoDisponivel      : reg_prato;
		listaMesasOcupadas   : reg_lista;
		cadastroMesas        : vetMesas;
		fila_vip             : reg_fila_tipo;
		fila_pref            : reg_fila_tipo;
		fila_outros          : reg_fila_tipo;

//Procedimento para inicializar o programa
procedure inicializa(var posicao:integer; var max:integer ; var max_prato:integer ; var posicaoPrato:integer ; var elemento:integer ; var maxLista:integer ; var posicaoLista:integer ; var fila_vip:reg_fila_tipo ; var fila_pref:reg_fila_tipo ; var fila_outros:reg_fila_tipo);
	begin
		posicao 			          := 1;
		max 					          := 10;
		max_prato 		          := 3;
		posicaoPrato 	          := 3;
		maxLista                := 5;
		elemento                := 1;
		posicaoLista            := 1;
		fila_vip.posicaoTipo    := 1;
		fila_pref.posicaoTipo   := 1;
		fila_outros.posicaoTipo := 1;
		fila_vip.maxTipo        := 5;
		fila_pref.maxTipo       := 5;
		fila_outros.maxTipo     := 5;
		maxMesas                := 5;
		for i:=1 to max_prato do
			pratoDisponivel.A_pratos[i] := i;
	end;
	
//Procedimento clear screen
procedure clearScreen();
	begin
		writeln('Clique qualquer tecla para continuar');
		readkey;
		clrscr;
	end;

//Functions valida��es clientes


//Functions valida��es prato		
function isPratoDisponivel(var posicaoPrato: integer):boolean;
	begin
		if posicaoPrato > 0 then
			isPratoDisponivel := true
		else
			isPratoDisponivel	:= false;				
	end;
	
function isPratoPilhaCheia(var posicaoPrato:integer):boolean;
	begin
		if posicaoPrato = 3 then
			isPratoPilhaCheia := true
		else
			isPratoPilhaCheia := false;	
	end;
	
function retiraPratoPilha(var posicaoPrato:integer):integer;
	begin
		retiraPratoPilha := posicaoPrato - 1;	
	end;
	
function repoePratoPilha(var posicaoPrato:integer):integer;
	begin
		repoePratoPilha := 3; 	
	end;
	
//Functions valida��es lista de mesas 
function posicaoMesaRetirar(listaMesasOcupadas:reg_lista):integer;
var i:integer;
	begin
		for i:=1 to listaMesasOcupadas.maxLista do
			if listaMesasOcupadas.mesasOcupadas[i] = listaMesasOcupadas.elemento then
				posicaoMesaRetirar := i;	
	end;                                                                                            
	
function posicaoMesaRetirarCliente(cadastroMesas:vetMesas ; elemento:integer):integer;
var i:integer;
	begin
		for i:=1 to maxMesas do
			if cadastroMesas[i].numeroMesa = elemento then
				posicaoMesaRetirarCliente := i;	
	end;
	
//Functions valida��es fila de clientes por tipo
function isFilaTipoVazia(fila:reg_fila_tipo):boolean;
	begin
		if fila.posicaoTipo = 1 then
			isFilaTipoVazia := true
		else
			isFilaTipoVazia := false;		
	end;
	
//Functions de resumo para o caixa
function totalClientesAtendidos():integer;
var i,aux:integer;
	begin
		aux:=1;
		for i:=1 to 10 do
			if cadastro_clientes[i].clicodigo	> aux then
				aux := cadastro_clientes[i].clicodigo;
		totalClientesAtendidos := aux;	
	end;
	
//Procedimento dos pratos	
procedure pegaPrato(var cliente:reg_cliente ; var pratoDisponivel:reg_prato);
	begin
		writeln('Cliente ', cliente.nome,' pegou um prato');
		pratoDisponivel.posicaoPrato := retiraPratoPilha(pratoDisponivel.posicaoPrato);			
	end;
	
procedure consultaPrato(var pratoDisponivel:reg_prato);
	begin
		if isPratoDisponivel(pratoDisponivel.posicaoPrato) = true then
				writeln('Existem ', pratoDisponivel.posicaoPrato,' pratos dispon�veis')
		else if isPratoDisponivel(pratoDisponivel.posicaoPrato) = false then
			writeln ('Precisa repor pratos, n�o tem pratos dispon�veis');	
	end;
	
procedure reporPrato(var posicaoPrato:integer);
	begin
		if isPratoPilhaCheia(pratoDisponivel.posicaoPrato) then
			writeln('A pilha de pratos j� est� cheia')
		else if not isPratoPilhaCheia(pratoDisponivel.posicaoPrato) then
			posicaoPrato := repoePratoPilha(pratoDisponivel.posicaoPrato);
		clearScreen();
	end;	

//Procedimento de clientes
procedure inserirCliente(var cliente:reg_cliente);
	begin
		if isPratoDisponivel(pratoDisponivel.posicaoPrato) then
			begin
				inc(cliente.clicodigo);
				writeln('Escreva o nome do cliente:');
				readln(cliente.nome);
				writeln('Qual o tipo do cliente?');
				writeln('Tipos:');
				writeln('1 - VIP');
				writeln('2 - Preferencial');
				writeln('3 - Outros');
				readln(cliente.tipo);
				for i:=cliente.clicodigo to cliente.clicodigo do
					cadastro_clientes[i]:= cliente;
				pegaPrato(cliente,pratoDisponivel);
			end
		else if not isPratoDisponivel(pratoDisponivel.posicaoPrato) then
			writeln ('Precisa repor pratos, n�o tem pratos dispon�veis');
		clearScreen();	
	end;
	
procedure consultarCliente(var cliente:reg_cliente);
	begin
		for i:=1 to cliente.clicodigo do
			begin
				writeln('Nome: ',cadastro_clientes[i].nome,' - Tipo: ',cadastro_clientes[i].tipo,'');
			end;
	end;

procedure totalPedidoCliente(var clienteCaixa:reg_cliente);
	begin
		write('Digite o valor total do pedido do cliente ',clienteCaixa.nome,': ');
		readln(clienteCaixa.valorPedido);
		writeln;
		writeln('----Digite a forma de pagamento do cliente, sendo----');
		writeln('----             1 - Cart�o                      ----');
		writeln('----             2 - Dinheiro                    ----');
		writeln('-----------------------------------------------------');
		readln(clienteCaixa.tipoPagamento);
		if clienteCaixa.tipoPagamento = 1 then
			totalCartao := totalCartao + clienteCaixa.valorPedido	
		else if clienteCaixa.tipoPagamento = 2 then
			totalDinheiro := totalDinheiro + clienteCaixa.valorPedido;	
	end;

//Procedimento da fila de clientes �nica
procedure insereClienteFila(var cliente:reg_cliente; var fila:reg_fila);
	begin
		fila.fila_clientes[fila.posicao] := cliente;
		inc(fila.posicao);
	end;
	
procedure removeClientesFila(var cliente:reg_cliente; var fila:reg_fila);
	begin
		for i:=2 to fila.posicao-1	do
			fila.fila_clientes[i-1] := fila.fila_clientes[i];
		fila.posicao := fila.posicao - 1;
	end;
		
procedure consultarFilaClientes(var fila:reg_fila); 
	begin
		for i:=1 to fila.posicao - 1 do
			write(fila.fila_clientes[i].nome,' || ');
		writeln;
	end;
	
//Procedimento de fila de clientes por tipo
procedure insereClienteFilaPorTipo(var cadastroMesas:vetMesas ; var fila_vip:reg_fila_tipo ; var fila_pref:reg_fila_tipo ; var fila_outros:reg_fila_tipo ; listaMesasOcupadas:reg_lista);
var posicaoExclude:integer;
	begin
		posicaoExclude := posicaoMesaRetirarCliente(cadastroMesas,listaMesasOcupadas.elemento);
		if cadastroMesas[posicaoExclude].cliente_mesa.tipo = 1 then
			begin
				fila_vip.cliente_tipo[fila_vip.posicaoTipo] := cadastroMesas[posicaoExclude].cliente_mesa;
				inc(fila_vip.posicaoTipo);
			end
		else if cadastroMesas[posicaoExclude].cliente_mesa.tipo = 2 then
			begin
				fila_pref.cliente_tipo[fila_pref.posicaoTipo] := cadastroMesas[posicaoExclude].cliente_mesa;
				inc(fila_pref.posicaoTipo);
			end
		else if cadastroMesas[posicaoExclude].cliente_mesa.tipo = 3 then
			begin
				fila_outros.cliente_tipo[fila_outros.posicaoTipo] := cadastroMesas[posicaoExclude].cliente_mesa;
				inc(fila_outros.posicaoTipo);
			end;
	end;

procedure removeClienteFilaPorTipo(var fila:reg_fila_tipo);
var i:integer;
	begin
		for i:=2 to fila.posicaoTipo -1 do
			fila.cliente_tipo[i-1] := fila.cliente_tipo[i];
		dec(fila.posicaoTipo);
	end;

procedure consultarFilaClientesTipo(var fila:reg_fila_tipo);
var i:integer;
	begin
		for i:= 1 to fila.posicaoTipo -1 do
			write(fila.cliente_tipo[i].nome,' || ');
		writeln;
	end;

//Procedimento de cadastro/manuten��o das mesas
procedure cadastrarMesa(var cadastroMesas:vetMesas);
	begin
		writeln('Para iniciar, � necess�rio cadastrar o n�mero das 5 mesas existentes em seu restaurante');
		for i:=1 to maxMesas do
			begin
				writeln('Digite o n�mero de uma mesa');
				readln(cadastroMesas[i].numeroMesa);
				cadastroMesas[i].isMesaOcupada := false;
			end;
		clearScreen();
	end;
	
procedure setaMesaDisponivel(var cadastroMesas:vetMesas; elemento:integer);
var i:integer;
	begin
		for i:=1 to listaMesasOcupadas.maxLista do
			if cadastroMesas[i].numeroMesa = elemento then
				cadastroMesas[i].isMesaOcupada := false; 
	end;
		
procedure setaMesaOcupada(var cadastroMesas:vetMesas; elemento:integer);
	begin
		for i:=1 to listaMesasOcupadas.maxLista do
			if cadastroMesas[i].numeroMesa = listaMesasOcupadas.elemento then
				cadastroMesas[i].isMesaOcupada := true;	
	end;
	
procedure insereClienteMesa (var cadastroMesas:vetMesas ; maxLista:integer ; elemento:integer ; var fila_clientes:vet_cliente);
var i:integer;
	begin
		for i:=1 to maxLista do
			if cadastroMesas[i].numeroMesa = elemento then
				cadastroMesas[i].cliente_mesa := fila_clientes[1];	
	end;	

//Procedimento da lista de mesas
procedure removeMesaLista (var listaMesasOcupadas:reg_lista ; var cadastroMesas:vetMesas ; var fila_vip:reg_fila_tipo ; var fila_pref:reg_fila_tipo ; var fila_outros:reg_fila_tipo);
var i, posicaoExclude:integer;
	begin
		writeln('Digite a mesa que deseja liberar');
		readln(listaMesasOcupadas.elemento);
		posicaoExclude := posicaoMesaRetirar(listaMesasOcupadas);
		if posicaoExclude = 5 then
			begin
				dec(listaMesasOcupadas.posicaoLista);
				setaMesaDisponivel(cadastroMesas,listaMesasOcupadas.elemento);
			end
		else
			begin
				for i:= posicaoExclude to listaMesasOcupadas.maxLista-1 do
					listaMesasOcupadas.mesasOcupadas[i] := listaMesasOcupadas.mesasOcupadas[i+1];
				setaMesaDisponivel(cadastroMesas,listaMesasOcupadas.elemento);
				dec(listaMesasOcupadas.posicaoLista);
			end;
		insereClienteFilaPorTipo(cadastroMesas,fila_vip,fila_pref,fila_outros,listaMesasOcupadas);
		clearScreen();	
	end;	
	
procedure insereMesaLista (var listaMesasOcupadas:reg_lista ; var cadastroMesas:vetMesas ; var fila_clientes:vet_cliente);
var i:integer;
	begin
		listaMesasOcupadas.mesasOcupadas[listaMesasOcupadas.posicaoLista] := listaMesasOcupadas.elemento;
		setaMesaOcupada(cadastroMesas,listaMesasOcupadas.elemento);     
		inc(listaMesasOcupadas.posicaoLista);	
	end;

procedure escolheMesa(var listaMesasOcupadas:reg_lista ; var fila_clientes:vet_cliente ; var cadastroMesas:vetMesas);
	begin
		write('Digite a mesa escolhida pelo cliente ',fila_clientes[1].nome,': ');
		readln (listaMesasOcupadas.elemento);
		insereClienteMesa(cadastroMesas,listaMesasOcupadas.maxLista,listaMesasOcupadas.elemento, fila_clientes);	
		insereMesaLista(listaMesasOcupadas,cadastroMesas,fila_clientes);
		removeClientesFila(cliente,fila);
		clearScreen();
	end;

procedure escreveListaMesas(listaMesasOcupadas:reg_lista ; cadastroMesas:vetMesas);
var i:integer;
	begin
		for i:=1 to listaMesasOcupadas.maxLista do
			begin
				write('Mesa ',cadastroMesas[i].numeroMesa,': ');
				if cadastroMesas[i].isMesaOcupada = true then
					write('Ocupada ; ')
				else 
					write('Vazia ; ');
			end;
		writeln;  	
	end;
	
//Procedimentos de atendimento do caixa
procedure atenderCliente(var fila_vip:reg_fila_tipo ; var fila_pref:reg_fila_tipo ; var fila_outros:reg_fila_tipo);
	begin
		if not isFilaTipoVazia(fila_vip) then
			begin
				totalPedidoCliente(fila_vip.cliente_tipo[1]);
				removeClienteFilaPorTipo(fila_vip);
			end
		else if not isFilaTipoVazia(fila_pref) then
			begin
				totalPedidoCliente(fila_pref.cliente_tipo[1]);
				removeClienteFilaPorTipo(fila_pref);
			end
		else if not isFilaTipoVazia(fila_outros) then
			begin
				totalPedidoCliente(fila_outros.cliente_tipo[1]);
				removeClienteFilaPorTipo(fila_outros);
			end
		else
			writeln('N�o possui nenhum cliente para atender.');
		clearScreen();	
	end;
	
//Procedimentos de resumo do caixa
procedure resumoCaixa();
	begin
		writeln('---- Resumo do Caixa ----');
		writeln('Total de clientes atendidos: ',totalClientesAtendidos());
		writeln('Total de valor do caixa em Cart�o: ',totalCartao);
		writeln('Total de valor do caixa em Dinheiro: ',totalDinheiro);
		writeln('-------------------------');
		clearscreen();
	end;

//Procedimento menu do caixa
procedure menuCaixa();
var escolhaCaixa:integer;
	begin
		while escolhaCaixa <> 3 do
			begin
				writeln;
				writeln('---------Fila de clientes VIP para o caixa---------');
				consultarFilaClientesTipo(fila_vip);
				writeln('---------------------------------------------------');
				writeln;
				writeln('---------Fila de clientes PREFERENCIAL para o caixa---------');
				consultarFilaClientesTipo(fila_pref);
				writeln('------------------------------------------------------------');
				writeln;
				writeln('---------Fila de outros clientes para o caixa---------');
				consultarFilaClientesTipo(fila_outros);
				writeln('------------------------------------------------------');
				writeln;
				writeln('---------Escolha uma op��o---------');
				writeln('-   1 - Atender Cliente           -');
				writeln('-   2 - Resumo do caixa           -');
				writeln('-   3 - Voltar ao menu inicial    -');
				writeln('-----------------------------------');
				readln(escolhaCaixa);
				case escolhaCaixa of
					1 : atenderCliente(fila_vip,fila_pref,fila_outros);
					2 : resumoCaixa();
					3 : clearScreen();
				end;
		  end;
	end;	
	
//Procedimento Menu
procedure menu();                                           
var escolha:integer;
	begin
		while escolha <> 6 do
			begin
				writeln('---------Clientes cadastrados---------');
				consultarCliente(cliente);
				writeln('--------------------------------------');
				writeln;
				writeln('---------Fila de clientes---------');
				consultarFilaClientes(fila);
				writeln('----------------------------------');
				writeln;
				writeln('---------Situa��o das mesas---------');
				escreveListaMesas(listaMesasOcupadas,cadastroMesas);
				writeln('------------------------------------');
				writeln;
				consultaPrato(pratoDisponivel);
				writeln;
				writeln('---------Escolha uma op��o---------');
				writeln('-     1 - Inserir cliente         -');
				writeln('-     2 - Repor pratos            -');
				writeln('-     3 - Servir cliente          -');
				writeln('-     4 - Liberar mesa            -');
				writeln('-     5 - Verificar Caixa         -');
				writeln('-     6 - Sair                    -');
				writeln('-----------------------------------');
				readln(escolha);
				case escolha of
					1	:	begin
								inserirCliente(cliente);
								insereClienteFila(cliente,fila);
							end;       
					2	:	reporPrato(pratoDisponivel.posicaoPrato);	
					3	:	escolheMesa(listaMesasOcupadas,fila.fila_clientes,cadastroMesas);
					4 : removeMesaLista(listaMesasOcupadas,cadastroMesas,fila_vip,fila_pref,fila_outros);
					5 : begin
								clearScreen();
								menuCaixa();
							end;
					6	:	resumoCaixa();
		    end;
			end;
	end;	

Begin
	inicializa(fila.posicao,fila.max,pratoDisponivel.max_prato, pratoDisponivel.posicaoPrato,listaMesasOcupadas.elemento,listaMesasOcupadas.maxLista,listaMesasOcupadas.posicaoLista,fila_vip,fila_pref,fila_outros);
	cadastrarMesa(cadastroMesas);
	menu();
End.