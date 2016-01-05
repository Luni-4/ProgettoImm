%% ALGORITMO TRA I PRIMI DUE FRAME

	%% 
	% Prima iterazione
	%%
	
		%% 1_Immagine di partenza

		_____________________________________________

		|	20x20	20x20	20x20	20x20	20x20	|

		|	20x20	20x20	20x20	20x20	20x20	|

		|	20x20	20x20	20x20	20x20	20x20	|

		|	20x20	20x20	20x20	20x20	20x20	|

		|	20x20	20x20	20x20	20x20	20x20	|
		_____________________________________________

		Ogni blocco 20x20 rappresenta una regione

		%% 2_Ho flusso ottico per ogni regione
		u(x,y) e v(x,y)) per ogni quadrato 20x20

		%% 3_Elimino le regioni che hanno errore residuo troppo alto
		Avrò dei blocchi 20x20 che non saranno assegnati; di fatto, o il blocco era troppo grosso e conteneva regioni con movimenti diversi (improbabile), oppure siamo stati sfigati e abbiamo beccato il contorno di un qualche oggetto (molto più probabile).

		_____________________________________________________________					

		|	20x20		20x20		?20x20?		?20x20?		?20x20?	|				?20x20? blocco non assegnato

		|	20x20		20x20		20x20		?20x20?		?20x20?	|

		|	20x20		20x20		20x20		20x20		?20x20?	|

		|	?20x20?		?20x20?		20x20		20x20		?20x20?	|

		|	?20x20?		?20x20?		20x20		20x20		20x20	|
		_____________________________________________________________

		%% 4_Calcolo il k means adattivo sul piano movimento, considerando le regioni 20x20 ch mi sono rimaste 
		Avrò n macroregioni, ognuna formata da tanti blocchi 20x20

		%% 5_Osservo se le u(x,y) e v(x,y) di ogni pixel sono coerenti con u(x,y) v(x,y) delle macroregioni che ho fatto
		Alcune sì, molte no. Tiro fuori dalle regioni i pixel con errore residuo troppo alto.

		%% Provo a vedere se, tra i pixel non assegnati, alcuni di questi possono essere assegnati a regioni preesistenti
		Magari si trovavano in un blocco 20x20 appartenente ad un altra regione, ma sarebbero descritti meglio dalla regione immediatamente adiacente. Tentar non nuoce. Dovrebbe aiutare lungo i bordi.

		%% Passo al suddivisore di regioni
		Separo i blocchi 20x20 che sembrano poter far parte dello stesso movimento, ma non sono tra loro adiacenti

		%% Passo in un filtro di regioni
		Elimino le regioni troppo piccole

	%% 
	% FINE PRIMA ITERAZIONE
	%% 
	
	%%
	% INIZIO SECONDA ITERAZIONE
	%%

		%% 6_Cosa faccio con quelle rimanenti
		Alcune regioni, ancora delle 20x20 iniziali, non saranno nemmeno arrivate ad essere considerate all'interno del k means, perché le ipotesi sull'affine motion di quel particolare blocco avevano errore residuo troppo alto.

		Altri pixel invece, non risultando coerenti con u e v delle macroregioni, saranno non assegnatei mentre gli altri pixel del blocco di cui facevano parte sì.

		_____________________________________________________________

		|	ASSEGNATO	ASSEGNATO	20x20		20x20		20x20	|

		|	ASSEGNATO	ASSEGNATO	5x7			20x20		20x20	|

		|	10x8		15x7		ASSEGNATO	ASSEGNATO	20X20	|

		|	20x20		20x20		ASSEGNATO	ASSEGNATO	20X20	|

		|	20X20		20X20		ASSEGNATO	ASSEGNATO	5X5		|
		_____________________________________________________________

		Suddivido i blocchi 20x20 in sottoblocchi da 10x10:

		_________________________________________________________________________________

		|	ASSEGNATO		ASSEGNATO		10x10|10x10		10x10|10x10		10x10|10x10	|
		|	(regione 1)		(regione 1)		10x10|10x10		10x10|10x10		10x10|10x10	|
		|
		|
		|	ASSEGNATO		ASSEGNATO		5x7				10x10|10x10		10x10|10x10	|
		|	(regione 1)		(regione 1)						10x10|10x10		10x10|10x10	|
		|
		|	10x8			15x7			ASSEGNATO		ASSEGNATO		10X10|10x10	|
		|									(regione 2)		(regione 2)		10x10|10x10
		|
		|	10x10|10x10		10x10|10x10		ASSEGNATO		ASSEGNATO		10x10|10x10	|
		|	10x10|10x10		10x10|10x10		(regione 2)		(regione 2)		10x10|10x10	|
		|
		|	10x10|10x10		10x10|10x10		ASSEGNATO		ASSEGNATO		5X5			|
		|	10x10|10x10		10x10|10x10
		_________________________________________________________________________________


		%% 7_Ricalcolo le ipotesi sull'affine motion, sia sulle vecchie regioni, sia sui nuovi blocchi
		Questa volta, con pixel 10x10, si spera che non ci siano errori residui troppo alti; se ci fossero, poi faremo un'altra iterazione.
		
		%% Calcolo l'errore residuo sulle regioni
		Come passaggio precedente

		%% 8_Ricalcolo il k means adattivo, partendo dalle macroregioni trovate precedentemente (che quindi saranno molte di meno), sia i 10x10 che quelli formati dai vecchi pixel rimasti inassegnati
		Considero quindi macroregioni trovate precedentemente, nuove regioni 10x10, e regioni formate da pixel sciolti.
		
		%%Osservo se le u(x,y) e v(x,y) di ogni pixel sono coerenti con u(x,y) v(x,y) delle macroregioni che ho fatto
		Alcune sì, molte no. Tiro fuori dalle regioni i pixel con errore residuo troppo alto.
		
		%% Provo a vedere se, tra i pixel non assegnati, alcuni di questi possono essere assegnati a regioni preesistenti
		Magari si trovavano in un blocco 20x20 appartenente ad un altra regione, ma sarebbero descritti meglio dalla regione immediatamente adiacente. Tentar non nuoce. Dovrebbe aiutare lungo i bordi.
		
		%% Passo in un filtro di regioni
		Elimino le regioni troppo piccole
		
	%% 
	% FINE SECONDA ITERAZIONE
	%% 
		
	%% SUCCESSIVE ITERAZIONI
	

		%% Seguo la logica della seconda iterazione
		Seguo lo stesso procedimento, e continuo ad iterare finché non raggiungo convergenza, quando solo pochi pixel vengono riassegnati o raggiungo numero massimo iterazioni (20 iterazioni)
		
	%%
	% FINE SUCCESSIVE ITERAZIONI
	%%
	
%% FINE ALGORITMO TRA PRIMI DUE FRAME

%% TRA COPPIE D I FRAME SUCCESSIVI

	%% Simile al precedente
	Unica cosa, quando facciamo il kmeans adattivo, partiamo dalle regioni precedenti, diminuendo di molto le iterazioni necessarie per arrivare a convergenza.
	
%% FINE