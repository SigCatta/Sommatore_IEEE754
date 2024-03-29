# Prova Finale di Reti Logiche - 2023
Valutazione 28 / 30
## Specifica
L'obbiettivo del progetto è l'implementazione di un sommatore floating point secondo lo standard IEEE754, comprensivo dei numeri speciali NaN e infinity, che calcoli correttamente la somma e la sottrazione esclusivamente di numeri normalizzati.
Il sommatore deve essere realizzato mediante una architettura pipelined, scegliendo la suddivisione in stadi il più possibile bilanciati. <br>
Una volta realizzato il componente, è richiesto di realizzare un test-bench per la simulazione e la verifica del corretto funzionamento nei diversi casi.
## Implementazione
Il dispositivo utilizza una pipeline a tre stadi i cui ritardi sono stati stimati rispettivamente a 25.4 ns, 27.0 ns e 25.3 ns, per questo si è deciso di utilizzare un segnale di clock di 30 ns, di seguito una rappresentazione semplificata degli stadi della pipeline:<br>
![alt text](https://github.com/SigCatta/Sommatore_IEEE754/blob/main/.pipelie.png)
Il primo stadio prende gli input del top-level produce i numeri X e Y normalizzati, DNORMX corrisponde sempre al numero più piccolo e DNORMY al numero più grande, nel caso il numero più piccolo sia negativo sarà prodotto il suo complemento a uno (a cui verrà sommato 1 nel prossimo stadio della pipeline per produrre il complemento a due), il numero più grande viene invece eventualmente inoltrato in complemento a due. Gli input del top-level sono inoltre analizzati dal modulo CLU per produrre i segnali PINF, NINF e NAN (tutti da un solo bit) che indicano se l’output dell’operazione è un numero speciale, è importante notare che questi segnali sono one-hot, non è infatti possibile che il risultato possa essere allo stesso tempo due numeri speciali diversi. Questi segnali possono valere 1 solo se almeno uno degli input del top-level è un numero speciale. Viene anche inoltrato allo stadio successivo l’esponente del numero più grande. <br>
Il secondo stadio si occupa di eseguire la somma tra le mantisse dei numeri denormalizzati e di produrre un segnale su 24 bit che rappresenta la mantissa denormalizzata (comprensiva dell’1 omesso nella rappresentazione normalizzata) in notazione unsigned. Vengono poi inoltrati allo stadio successivo il segnale SIGN da un solo bit dal valore 1 se il risultato dell’operazione è negativo, 0 altrimenti (non è previsto un valore fisso per SIGN nel caso il risultato sia zero) e il segnale INCR da un bit che indica se a causa di un overflow nella somma sarà necessario incrementare l’esponente del risultato. I segnali non utilizzati sono inoltrati allo stadio successivo.<br>
Il terzo stadio si occupa in primo luogo di normalizzare il risultato ottenuto allo stadio precedente shiftando la mantissa M a destra o a sinistra in base all’output di un priority encoder e sottraendo al segnale EXP il numero di bit di cui la mantissa viene shiftata verso destra. Dopo aver ottenuto un numero normalizzato si controlla in base ai valori dei segnali PINF, NINF e NAN se il risultato deve essere modificato a causa di un operando speciale. Il segnale SIGN viene copiato nel bit più significativo del risultato per indicare il segno. <br>
È bene ricordare che gli ingressi e le uscite sono campionate ogni 30 ns, l’output corretto sarà quindi disponibile solo dopo quattro cicli di clock.<br><br>
Per ulteriori dettagli sull'implementazione e sulla funzione dei test bench, consultare la [documentazione](https://github.com/SigCatta/Sommatore_IEEE754/blob/main/.Relazione.pdf).

## Utilizzo
Per testare il funzionamento del dispositivo è necessario creare un nuovo progetto sulla piattaforma [Xilinx ISE](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive-ise.html), successivamente dopo aver aggiunto tutti i file .vhd al progetto (non è necessario aggiungere i test bench, il cui nome termina per _TB) si potrà procedere alla creazione di nuovi test bech per verificare il corretto funzionamento del dispositivo.<br>
Si noti che l'implementazione presente è stata progettata e testa per un dispositivo Spartan6 XC6slx75T del package FGG676 con velocità -4, l'utilizzo di dispositivi diversi potrebbe non essere supportata.

## Membri del gruppo

- [__Luca Cattani__](https://github.com/SigCatta)
- [__Manuela Marenghi__](https://github.com/manuelamarenghi)
