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

%% 4_Calcolo il k means sul piano movimento, considerando le regioni 20x20 ch mi sono rimaste (con k=4)
Avrò 4 macroregioni, ognuna formata da tanti blocchi 20x20

%% 5_Osservo se le u(x,y) e v(x,y) di ogni pixel sono coerenti con u(x,y) v(x,y) delle 4 macroregioni che ho fatto
Alcune sì, molte no.

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
|	(regione 1)		(regione 1)		0x10|10x10		10x10|10x10		10x10|10x10	|
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


%% 7_Ricalcolo le ipotesi sull'affine motion sui nuovi blocchi
Questa volta, con pixel 10x10, si spera che non ci siano errori residui troppo alti; se ci fossero, poi faremo un'altra iterazione

%% 8_Ricalcolo il k means sui nuovi blocchi, sia i 10x10 che quelli formati dai vecchi pixel rimasti inassegnati
Considero solo i pixel che non erano stati assegnti al punto 5, avrò quindi altre 4 macroregioni.

%% 9_Confronto le 4 macroregioni trovate al punto 5 con quelle trovate nel punto 8
Vedo se magari i valori di u e v di queste 8 macroregioni sono simili, se sì unisco le 2 o più regioni tra loro (serve questo passaggio ?). 

Penso che questo discorso abbia senso nel momento avessimo un numero massimo di layer che possiamo assegnare, altrimenti non dovrebbe essere necessario.

%% 10_ Continuo finché non ho asssegnato tutti i pixel ad una regione.
Ora dovrei avere fatto tutto per i primi 2 frame!

%% Ripetiamo il discorso per i frame 2 e 3, 3-4, ....
Solo, per risparmiare tempo, le regioni da cui partiremo non saranno più i blocchi 20x20, ma le regioni che abbiamo trovato alla fien del punto 10.

Se i movimenti sono stati piccoli, tra un frame all'altro sarà cambiata l'appartenenza ad una determinata regione solo di pochi pixel (che troveremo quando rifaremo il punto 5).