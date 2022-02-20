-- DataBase Script
SET NAMES latin1;
SET global event_scheduler=on;

BEGIN;
CREATE DATABASE progetto;
COMMIT;

USE progetto;
/*Area Produzione-----------------------------------------------------------------*/
DROP TABLE IF EXISTS `PRODOTTO_ELETTRONICO`;
CREATE TABLE `PRODOTTO_ELETTRONICO` (
`Marca` char(50) NOT NULL,
`CodiceSeriale` int(11) NOT NULL,
`Prezzo` int(11) NOT NULL,
`Garanzia (anni)` int(11) NOT NULL,
`NumeroFacce` int(11) NOT NULL,
`Nome` char(50) NOT NULL,
`Stato` char(50) NOT NULL, /*metterci anche in manutenzione*/
`Modello` char(50) ,
`Lotto` int(11) NOT NULL,
`tipo` char(50) NOT NULL,
PRIMARY KEY (`Marca`,`CodiceSeriale`),
CHECK ( Stato = "Disponibile" OR Stato = "In produzione" 
	OR Stato = "Venduto" OR Stato = "Reso" OR Stato = "In manutenzione")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SMART_DEVICE`;
CREATE TABLE `SMART_DEVICE` (
`Marca` char(50) NOT NULL,
`CodiceSeriale` int(11) NOT NULL,
`PolliciSchermo` int(11) NOT NULL,
`Ram(GB)` int(11) NOT NULL,
`Tipo` char(50) NOT NULL,
`Caratteristica1` char(50),
`Caratteristica2` char(50),
FOREIGN KEY (`Marca`,`CodiceSeriale`) REFERENCES `PRODOTTO_ELETTRONICO` (`Marca`,`CodiceSeriale`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ELETTRODOMESTICO`;
CREATE TABLE `ELETTRODOMESTICO` (
`Marca` char(50) NOT NULL,
`CodiceSeriale` int(11) NOT NULL,
`Tipo` char(50) NOT NULL,
`Consumo(watt)` int(11) NOT NULL,
`Caratteristica1` char(50),
`Caratteristica2` char(50),
FOREIGN KEY (`Marca`,`CodiceSeriale`) REFERENCES `PRODOTTO_ELETTRONICO` (`Marca`,`CodiceSeriale`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `RADIO`;
CREATE TABLE `RADIO` (
`Marca` char(50) NOT NULL,
`CodiceSeriale` int(11) NOT NULL,
`Batteria(mah)` int(11) NOT NULL,
`NumeroAntenne` int(11) NOT NULL,
FOREIGN KEY (`Marca`,`CodiceSeriale`) REFERENCES `PRODOTTO_ELETTRONICO` (`Marca`,`CodiceSeriale`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `UNITA_PERSA`;
CREATE TABLE `UNITA_PERSA` (
`Marca` char(50) NOT NULL,
`CodiceSeriale` int(11) NOT NULL,
`Stazione` int(11) NOT NULL,
`Data` date NOT NULL,
FOREIGN KEY (`Marca`,`CodiceSeriale`) REFERENCES `PRODOTTO_ELETTRONICO` (`Marca`,`CodiceSeriale`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `LOTTO`;
CREATE TABLE `LOTTO` (
`Codice` int(11) NOT NULL,
`NumeroUnita` int(11) NOT NULL,
`DataInizioProduzione` date NOT NULL,
`DataFineProduzione` date,
`Stato` char(50) NOT NULL,
`NumeroUnitaPerse` int(11) NOT NULL,
`Tempo necessario per la rotazione (s)` int(11) NOT NULL,
`Magazzino` char(50) NOT NULL,
`Sede` char(50) NOT NULL,
`Sequenza` int(11) NOT NULL,
PRIMARY KEY (`Codice`),
CHECK (Stato='in produzione' OR Stato='concluso')
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SEDE`;
CREATE TABLE `SEDE` (
`Città` char(50) NOT NULL,
`Nome` char(50) NOT NULL,
PRIMARY KEY (`Città`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `MAGAZZINO`;
CREATE TABLE `MAGAZZINO` (
`Nome` char(50) NOT NULL,
`Sede` char(50) NOT NULL,
`Predisposizione` char(50) NOT NULL,
`Capienza` int(11) NOT NULL,
`UnitaContenute` int(11) NOT NULL DEFAULT 0,
PRIMARY KEY (`Nome`),
FOREIGN KEY (`Sede`) REFERENCES `SEDE`(`Città`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `CONTENUTO_CORRENTE`;
CREATE TABLE `CONTENUTO_CORRENTE` (
`Magazzino` char(50) NOT NULL,
`Sede` char(50) NOT NULL,
`Marca` char(50) NOT NULL,
`CodiceSeriale` int(11) NOT NULL,
PRIMARY KEY (`Magazzino`, `Sede`, `Marca`, `CodiceSeriale`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `CONTENUTO_STORICO`;
CREATE TABLE `CONTENUTO_STORICO` (
`Magazzino` char(50) NOT NULL,
`Sede` char(50) NOT NULL,
`Marca` char(50) NOT NULL,
`CodiceSeriale` int(11) NOT NULL,
`InizioPermanenza` date NOT NULL,
`FinePermanenza` date NOT NULL,
PRIMARY KEY (`Magazzino`, `Sede`, `Marca`, `CodiceSeriale`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ORGANIZZAZIONE_LINEA_PRODUZIONE`;
CREATE TABLE `ORGANIZZAZIONE_LINEA_PRODUZIONE` (
`Lotto` int(11) NOT NULL,
`Stazione` int(11)NOT NULL,
`OrientazioneProdotto` char(50)NOT NULL,
`TempoT(minuti)` int(11)NOT NULL,
PRIMARY KEY (`Lotto`, `Stazione`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `STAZIONE`;
CREATE TABLE `STAZIONE` (
`CodiceStazione` int(11) NOT NULL,
PRIMARY KEY (`CodiceStazione`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `OPERATORE`;
CREATE TABLE `OPERATORE` (
`CodiceFiscale` char(50) NOT NULL,
`Nome` char(50) NOT NULL,
`Eta` int(11) NOT NULL,
`Stipendio` int(11) NOT NULL,
`IndicePerformance` int(11),
`Stazione` int(11) NOT NULL,
PRIMARY KEY (`CodiceFiscale`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `CONTROLLO_TEMPI`;
CREATE TABLE `CONTROLLO_TEMPI`(
`Operatore` char(50) NOT NULL,
`Operazione` int(11) NOT NULL,
`Dataverifica` date NOT NULL,
`TempoDiEsecuzioneMin` int(11) NOT NULL,
PRIMARY KEY (`Operatore`, `Operazione`,`Dataverifica`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `OPERAZIONE`;
CREATE TABLE `OPERAZIONE` (
`IdOperazione` int(11)NOT NULL,
`Nome` char(50)NOT NULL,
`MontaggioSmontaggio` char(50)NOT NULL,
`TempoDiEsecuzioneIdealeMin` int(11)NOT NULL,
`Utensile` char(50),
`ElementoDiGiunzione` int(11) NOT NULL,
`Parte1` int(11)NOT NULL,
`Parte2` int(11)NOT NULL,
`faccia`int(11) NOT NULL,
`PrimaOperazione?` bool NOT NULL,
PRIMARY KEY (`IdOperazione`),
CHECK (MontaggioSmontaggio = "Montaggio" OR MontaggioSmontaggio = "Smontaggio")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `GIUNZIONE`;
CREATE TABLE `GIUNZIONE` (
`Parte1` int(11)NOT NULL,
`Parte2` int(11)NOT NULL,
`ElementoDiGiunzione` int(11)NOT NULL,
PRIMARY KEY (`Parte1`,`Parte2`, `ElementoDiGiunzione`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `PRECEDENZA_TECNOLOGICA_IMMEDIATA`;
CREATE TABLE `PRECEDENZA_TECNOLOGICA_IMMEDIATA`(
`OperazionePrecedente` int(11) NOT NULL,
`OperazioneSuccessiva` int(11) NOT NULL,
PRIMARY KEY (`OperazionePrecedente`, `OperazioneSuccessiva`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `COMPOSIZIONE_PARTE`;
CREATE TABLE `COMPOSIZIONE_PARTE` (
`Parte` int(11) NOT NULL,
`Materiale` char(50)NOT NULL,
`Quantitativo(g)` int(11)NOT NULL,
PRIMARY KEY (`Parte`, `Materiale`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `APPLICAZIONE`;
CREATE TABLE `APPLICAZIONE` (
`Sequenza` int(11) NOT NULL,
`Operazione` int(11) NOT NULL,
`PosizioneNellaSequenza` int(11) NOT NULL,
PRIMARY KEY (`Sequenza`,`posizioneNellaSequenza`,`Operazione`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ELEMENTO_DI_GIUNZIONE`;
CREATE TABLE `ELEMENTO_DI_GIUNZIONE` (
`CodiceElemento` int(11) NOT NULL,
PRIMARY KEY (`CodiceElemento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `FASCETTA`;
CREATE TABLE `FASCETTA` (
`CodiceElemento` int(11) NOT NULL,
`Lunghezza(cm)` int(11) NOT NULL,
PRIMARY KEY (`CodiceElemento`),
FOREIGN KEY (`CodiceElemento`) REFERENCES `ELEMENTO_DI_GIUNZIONE`(`CodiceElemento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `MASTICE`;
CREATE TABLE `MASTICE` (
`CodiceElemento` int(11) NOT NULL,
`MaterialeIdeale` char(50) NOT NULL,
PRIMARY KEY (`CodiceElemento`),
FOREIGN KEY (`CodiceElemento`) REFERENCES `ELEMENTO_DI_GIUNZIONE`(`CodiceElemento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `GUARNIZIONE`;
CREATE TABLE `GUARNIZIONE` (
`CodiceElemento` int(11) NOT NULL,
`Materiale` char(50) NOT NULL,
PRIMARY KEY (`CodiceElemento`),
FOREIGN KEY (`CodiceElemento`) REFERENCES `ELEMENTO_DI_GIUNZIONE`(`CodiceElemento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `VITE`;
CREATE TABLE `VITE` (
`CodiceElemento` int(11) NOT NULL,
`Diametro(mm)` int(11) NOT NULL,
`Passo(mm)`int(11) NOT NULL,
`Lunghezza(mm)`int(11) NOT NULL,
PRIMARY KEY (`CodiceElemento`),
FOREIGN KEY (`CodiceElemento`) REFERENCES `ELEMENTO_DI_GIUNZIONE`(`CodiceElemento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `RIVETTO`;
CREATE TABLE `RIVETTO` (
`CodiceElemento` int(11) NOT NULL,
`Lunghezza` int(11) NOT NULL,
PRIMARY KEY (`CodiceElemento`),
FOREIGN KEY (`CodiceElemento`) REFERENCES `ELEMENTO_DI_GIUNZIONE`(`CodiceElemento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `BULLONE`;
CREATE TABLE `BULLONE` (
`CodiceElemento` int(11) NOT NULL,
`Diametro(mm)` int(11) NOT NULL,
PRIMARY KEY (`CodiceElemento`),
FOREIGN KEY (`CodiceElemento`) REFERENCES `ELEMENTO_DI_GIUNZIONE`(`CodiceElemento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `PARTE`;
CREATE TABLE `PARTE` (
`CodiceParte` int(11)NOT NULL,
`Nome` char(50)NOT NULL,
`Prezzo` int(6)NOT NULL,
`Peso (g)` int(6)NOT NULL,
`Garanzia(anni)` int(5)NOT NULL,
`CoefficienteDiSvalutazione(Euro/Mese)` int(11)NOT NULL,
PRIMARY KEY (`CodiceParte`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `UTENSILI`;
CREATE TABLE `UTENSILI` (
`Nome` char(50)NOT NULL,
`Materiale` char(50) NOT NULL,
PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SEQUENZA`;
CREATE TABLE `SEQUENZA` (
`CodiceSequenza` int(11)NOT NULL,
`numeroRotazioni` int(11),
`TempoTotaleIdealeMinuti`int(11),
`IndicatorePerformanceUnitaPerse` int(11),
`MontaggioSmontaggio` char(50),
PRIMARY KEY (`CodiceSequenza`),
CHECK (MontaggioSmontaggio='montaggio' OR MontaggioSmontaggio='smontaggio')
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `OPERAZIONI_MANCANTI`;
CREATE TABLE `OPERAZIONI_MANCANTI` (
`Marca` char(50)NOT NULL,
`CodiceSeriale` int(11)NOT NULL,
`Operazione` int(11)NOT NULL,
PRIMARY KEY (`Marca`,`CodiceSeriale`,`Operazione`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `COMPOSIZIONE`;
CREATE TABLE `COMPOSIZIONE` (
`Marca` char(50)NOT NULL,
`CodiceSeriale` int(11)NOT NULL,
`Parte` int(11) NOT NULL,
PRIMARY KEY(`Marca`,`CodiceSeriale`,`Parte`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Area Vendita ----------------------------------------------------*/

DROP TABLE IF EXISTS `COMPOSTO`;
CREATE TABLE `COMPOSTO` (
`Marca` char(50)NOT NULL,
`CodiceSeriale` int(11)NOT NULL,
`Ordine` int(11)NOT NULL,
PRIMARY KEY(`Marca`,`CodiceSeriale`,`Ordine`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ORDINE`;
CREATE TABLE `ORDINE`(
`CodiceOrdine` int(11)NOT NULL,
`Stato` char(20)NOT NULL,
`DataRecezione` date,
`CostoTotale` int(11),
`Data` date NOT NULL,
`Account` char(50) NOT NULL,
`Spedizione` int(11),
PRIMARY KEY (`CodiceOrdine`),
CHECK (Stato = "In Processazione" OR Stato = "In Preparazione" 
	OR Stato = "Spedito" OR Stato = "Evaso")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ACCOUNT`;
CREATE TABLE `ACCOUNT`(
`Email` char(30)NOT NULL,
`Password` char(60)NOT NULL,
`DomandaPassword`char(100)NOT NULL,
`RispostaPassword`char(100)NOT NULL,
`Utente`char(30)NOT NULL,
`DataIscrizione` date NOT NULL,
PRIMARY KEY (`Email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `UTENTE`;
CREATE TABLE `UTENTE`(
`CodiceFiscale` char(30) NOT NULL,
`Nome` char(20)NOT NULL,
`Cognome`char(20)NOT NULL,
`NumeroTelefono` int(20)NOT NULL,
`Indirizzo` char(30)NOT NULL,
PRIMARY KEY (`CodiceFiscale`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SPEDIZIONE`;
CREATE TABLE `SPEDIZIONE`(
`CodiceSpedizione` int(11)NOT NULL,
`StatoSpedizione` char(20)NOT NULL,
`DataDiConsegnaPrevista` date NOT NULL,
`DataDiConsegnaEffettiva` date NOT NULL,
PRIMARY KEY(`CodiceSpedizione`),
CHECK (StatoSpedizione = "Spedito" OR StatoSpedizione = "In transito" 
	OR StatoSpedizione = "In consegna" OR StatoSpedizione = "Conseganta")
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `TRANSITA`;
CREATE TABLE `TRANSITA`(
`Spedizione` char(20)NOT NULL,
`Hub` int(11)NOT NULL,
`NumeroDiVisita` int(11)NOT NULL,
PRIMARY KEY(`Spedizione`,`Hub`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `HUB`;
CREATE TABLE `HUB`(
`CodiceHub`int(11)NOT NULL,
`Nome`char(20)NOT NULL,
PRIMARY KEY (`CodiceHub`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `RECENSIONE`;
CREATE TABLE `RECENSIONE`(
`CodiceRecensione` int(11)NOT NULL,
`Marca` char(20)NOT NULL,
`CodiceSeriale`int(11)NOT NULL,
`Ordine` int(11) NOT NULL,
`Performance`int(1)NOT NULL,
`Affidabilita`int(1)NOT NULL,
`EsperienzaDUso`int(1)NOT NULL,
`Testo`char(200),
PRIMARY KEY (`CodiceRecensione`),
CHECK ( Performance BETWEEN 1 AND 5 ),
CHECK ( Affidabilita BETWEEN 1 AND 5 ),
CHECK ( EsperienzaDUso BETWEEN 1 AND 5 )
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ESTENSIONE_GARANZIA`;
CREATE TABLE `ESTENSIONE_GARANZIA`(
`Marca` char(20)NOT NULL,
`CodiceSeriale` int(11)NOT NULL,
`CodiceFormula` int(11)NOT NULL,
PRIMARY KEY (`Marca`,`CodiceSeriale`,`CodiceFormula`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `FORMULE_DI_ESTENSIONE_GARANZIA`;
CREATE TABLE `FORMULE_DI_ESTENSIONE_GARANZIA`(
`CodiceFormula` int(11)NOT NULL,
`Costo` int(11)NOT NULL,
`Descrizione` char(50)NOT NULL,
PRIMARY KEY (`CodiceFormula`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Area Smontaggio---------------------------------------------------------------------*/

DROP TABLE IF EXISTS `UNITA_RICONDIZIONATA`;
CREATE TABLE `UNITA_RICONDIZIONATA` (
`Marca` char(20)NOT NULL,
`CodiceSeriale`int(11)NOT NULL,
`PrezzoScontato`int(10)NOT NULL,
`Categoria`char(50)NOT NULL,
PRIMARY KEY(`Marca`,`CodiceSeriale`),
FOREIGN KEY (`Marca`,`CodiceSeriale`) REFERENCES `PRODOTTO_ELETTRONICO`(`Marca`,`CodiceSeriale`),
CHECK ( Categoria = "A" OR Categoria ="B" )
)  ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `PARTI_SOSTITUITE`;
CREATE TABLE `PARTI_SOSTITUITE`(
`Marca`char(20)NOT NULL,
`CodiceSeriale`int(11)NOT NULL,
`Parte` int(11)NOT NULL,
PRIMARY KEY(`Marca`,`CodiceSeriale`,`Parte`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `RICHIESTA_RESO`;
CREATE TABLE `RICHIESTA_RESO`(
`Codice`int(11)NOT NULL,
`Marca`char(20)NOT NULL,
`CodiceSeriale`int(11)NOT NULL,
`Accettato?`bool,
`DirittoDiRecesso`bool NOT NULL,
`PoliticaRefubishment%`int(11) NOT NULL,
PRIMARY KEY(`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `CAUSATA`;
CREATE TABLE `CAUSATA`(
`Reso`int(11)NOT NULL,
`Difetto`int(11),
`Motivazione`int(11),
PRIMARY KEY(`Reso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `DIFETTO`;
CREATE TABLE `DIFETTO` (
`CodiceDifetto`int(11)NOT NULL,
`Nome`char(30)NOT NULL,
`Descrizione`char(200)NOT NULL,
PRIMARY KEY(`CodiceDifetto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `MOTIVAZIONE`;
CREATE TABLE `MOTIVAZIONE` (
`Codice`int(11)NOT NULL,
`Nome`char(30)NOT NULL,
`Descrizione`char(200)NOT NULL,
PRIMARY KEY(`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `CONTROLLO`;
CREATE TABLE `CONTROLLO`(
`Reso`int(11)NOT NULL,
`Test`int(11)NOT NULL,
`EsitoTest`bool NOT NULL,
PRIMARY KEY(`Reso`,`Test`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `TEST`;
CREATE TABLE `TEST` (
`Codice`int(11)NOT NULL,
`Nome`char(50)NOT NULL,
`Descrizione`char(50)NOT NULL,
PRIMARY KEY(`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `PRECEDENZASUCCESSIONE`;
CREATE TABLE `PRECEDENZASUCCESSIONE` (
`TestPrecedente`int(11)NOT NULL,
`TestSuccessivo`int(11)NOT NULL,
PRIMARY KEY(`TestPrecedente`,`TestSuccessivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `VERIFICA`;
CREATE TABLE `VERIFICA` (
`Test`int(11)NOT NULL,
`Parte`int(11)NOT NULL,
PRIMARY KEY(`Test`,`Parte`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SISTEMAZIONE`;
CREATE TABLE `SISTEMAZIONE` (
`Reso`int(11)NOT NULL,
`Lotto`int(11)NOT NULL,
PRIMARY KEY(`Reso`,`Lotto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `LOTTO_DI_RESI`;
CREATE TABLE `LOTTO_DI_RESI`(
`CodiceLotto`int(11)NOT NULL,
`NumeroUnita`int(11)NOT NULL,
`SogliaPerLoSmontaggio`int(11)NOT NULL,
`SequenzaDiSmontaggio`int(11),
PRIMARY KEY(`CodiceLotto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Area Assistenza------------------------------------------*/

DROP TABLE IF EXISTS `MANIFESTAZIONE`;
CREATE TABLE `MANIFESTAZIONE`(
`Marca`char(50)NOT NULL,
`CodiceSeriale`int(11)NOT NULL,
`Guasto`int(11)NOT NULL,
`Data`date NOT NULL,
PRIMARY KEY(`Marca`,`CodiceSeriale`,`Guasto`,`Data` )
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `GUASTO`;
CREATE TABLE `GUASTO`(
`CodiceGuasto`int(11)NOT NULL,
`Nome`char(50)NOT NULL,
`Descrizione`char(50)NOT NULL,
PRIMARY KEY(`CodiceGuasto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `CODICI_DI_ERRORE`;
CREATE TABLE `CODICI_DI_ERRORE`(
`Codice`int(11)NOT NULL,
`Guasto`int(11)NOT NULL,
PRIMARY KEY(`Codice`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `RIMEDIO`;
CREATE TABLE `RIMEDIO`(
`CodiceRimedio`int(11)NOT NULL,
`Descrizione`char(50)NOT NULL,
PRIMARY KEY(`CodiceRimedio`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `DOMANDA_ASSISTENZA_VIRTUALE`;
CREATE TABLE `DOMANDA_ASSISTENZA_VIRTUALE`(
`CodiceDomanda`int(11)NOT NULL,
`Domanda`char(50)NOT NULL,
`Rimedio`char(50)NOT NULL,
PRIMARY KEY(`CodiceDomanda`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `PRECEDENZA/SUCCESSIONE`;
CREATE TABLE `PRECEDENZA/SUCCESSIONE`(
`DomandaPrecedente`int(11)NOT NULL,
`DomandaSuccessiva`int(11)NOT NULL,
PRIMARY KEY(`DomandaPrecedente`,`DomandaSuccessiva`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ELABORAZIONE`;
CREATE TABLE `ELABORAZIONE`(
`Rimedio`int(11)NOT NULL,
`Tecnico`int(11)NOT NULL,
PRIMARY KEY(`Rimedio`,`Tecnico`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `TECNICO`;
CREATE TABLE `TECNICO`(
`CodiceTecnico`int(11)NOT NULL,
`CostoOra`int(11)NOT NULL,
PRIMARY KEY(`CodiceTecnico`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SPECIALIZZAZIONE`;
CREATE TABLE `SPECIALIZZAZIONE`(
`Tecnico`int(11)NOT NULL,
`Guasto`int(11)NOT NULL,
PRIMARY KEY(`Tecnico`,`Guasto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `RICHIESTA_ASSISTENZA_FISICA`;
CREATE TABLE `RICHIESTA_ASSISTENZA_FISICA`(
`Ticket`int(11)NOT NULL,
`Giorno`date NOT NULL,
`Ora`int(11)NOT NULL,
`Via`char(50)NOT NULL,
`NumeroCivico`int(11)NOT NULL,
`Citta`char(50)NOT NULL,
`Tecnico`int(11)NOT NULL,
PRIMARY KEY(`Ticket`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `PREVENTIVO`;
CREATE TABLE `PREVENTIVO`(
`CodicePreventivo`int(11)NOT NULL,
`RichiestaAssistenzaFisica`int(11)NOT NULL,
`Data` date NOT NULL,
`Scadenza(mesi)`int(11)NOT NULL,
`e'NecessarioPrelevarlo?`bool NOT NULL,
`Costo`int(11)NOT NULL,
`accettato`bool NOT NULL,
PRIMARY KEY(`CodicePreventivo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `ORDINE_RIPARAZIONI`;
CREATE TABLE `ORDINE_RIPARAZIONI`(
`CodiceOrdine`int(11)NOT NULL,
`Preventivo`int(11)NOT NULL,
`DataConsegnaPrevista`date NOT NULL,
`DataConsegnaEffettiva`date,
`CostoTotaleParti`int(11),
PRIMARY KEY(`CodiceOrdine`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SECONDO_INTERVENTO`;
CREATE TABLE `SECONDO_INTERVENTO`(
`Preventivo`int(11)NOT NULL,
`Tecnico`int(11)NOT NULL,
`Data`date NOT NULL,
`Orario`int(11)NOT NULL,
`Ricevuta`int(11)NOT NULL,
`OreManodopera`int(11)NOT NULL,
PRIMARY KEY(`Preventivo`,`Tecnico`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `CALENDARIO`;
CREATE TABLE `CALENDARIO`(
`Tecnico`int(11)NOT NULL,
`GiornoDellaSettimana`char(50) NOT NULL,
`Data`date NOT NULL,
`Citta`char(50),
`8-10` bool NOT NULL,
`10-12`bool NOT NULL,
`12-14`bool NOT NULL,
`14-16`bool NOT NULL,
`16-18`bool NOT NULL,
PRIMARY KEY(`Tecnico`,`data` ),
FOREIGN KEY (`Tecnico`) REFERENCES `TECNICO` (`CodiceTecnico`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `COMPOSIZIONE_ORDINE`;
CREATE TABLE `COMPOSIZIONE_ORDINE`(
`OrdineRiparazioni` int (11) NOT NULL,
`Parte` int (11) NOT NULL,
PRIMARY KEY (`OrdineRiparazioni`,`Parte`)
)ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SMONTAGGIO`;
CREATE TABLE `SMONTAGGIO` (
`CodiceLotto` int(11) NOT NULL,
`CodiceSequenza` int(11) NOT NULL,
PRIMARY KEY (`CodiceLotto`,`CodiceSequenza`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `UTENSILE`;
CREATE TABLE `UTENSILE` (
`Nome` char(50) NOT NULL,
`Materiale` char(50) NOT NULL,
PRIMARY KEY (`Nome`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

DROP TABLE IF EXISTS `SOLUZIONE`;
CREATE TABLE `SOLUZIONE` (
`CodiceSoluzione` int(11) NOT NULL,
`Guasto` int(11) NOT NULL,
`ProblemaRisolto` bool,
`Rimedio` int(11) NOT NULL,
PRIMARY KEY (`CodiceSoluzione`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

---------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------- POPOLAMENTO ---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------

BEGIN;
INSERT INTO `PRODOTTO_ELETTRONICO` VALUES 
('SAMSUNG','000001','600','2','2','s10','disponibile','galaxy','1000001', 'smart device'),
('SAMSUNG','000002','600','2','2','s10','disponibile','galaxy','1000001','smart device'),
('SAMSUNG','000003','600','2','2','s10','venduto','galaxy','1000001','smart device'),
('SAMSUNG','000004','600','2','2','s10','disponibile','galaxy','1000001','smart device'),
('SAMSUNG','000005','600','2','2','s10','venduto','galaxy','1000001','smart device'),
('APPLE','000001','400','2','2','macbook','disponibile','air','1000002','smart device'),
('APPLE','000002','400','2','2','macbook','disponibile','air','1000002','smart device'),
('APPLE','000003','400','2','2','macbook','venduto','air','1000002','smart device'),
('APPLE','000004','400','2','2','macbook','disponibile','air','1000002','smart device'),
('APPLE','000005','400','2','2','macbook','venduto','air','1000002','smart device'),
('LG','000001','1250','3','6','GSX960NSAZ','in produzione',null,'1000003','elettrodomestico'),
('LG','000002','1250','3','6','GSX960NSAZ','in produzione',null,'1000003','elettrodomestico'),
('LG','000003','1250','3','6','GSX960NSAZ','in produzione',null,'1000003','elettrodomestico'),
('LG','000004','1250','3','6','GSX960NSAZ','in produzione',null,'1000003','elettrodomestico'),
('INDESIT','000001','250','3','6','BWA','venduto',null,'1000005','elettrodomestico'),
('INDESIT','000002','250','3','6','BWA','reso',null,'1000005','elettrodomestico'),
('SONY','000001','110','2','6','CMT','venduto',null,'1000004','radio'),
('SONY','000002','110','2','6','CMT','disponibile',null,'1000004','radio'),
('SONY','000003','110','2','6','CMT','disponibile',null,'1000004','radio'),
('SONY','000004','110','2','6','CMT','disponibile',null,'1000004','radio'),
('BOSCH','000001','220','2','6','HBF0','disponibile',null,'1000006','elettrodomestico'),
('BOSCH','000002','220','2','6','HBF0','in manutenzione',null,'1000006','elettrodomestico'),
('BOSCH','000003','220','2','6','HBF0','venduto',null,'1000006','elettrodomestico'),
('APPLE','000006','1200','2','2','iphone','in produzione','11','1000007','smart device'),
('APPLE','000007','1200','2','2','iphone','in produzione','11','1000007','smart device'),
('APPLE','000008','1200','2','2','iphone','reso','11','1000008','smart device'),
('APPLE','000009','1200','2','2','iphone','venduto','11','1000008','smart device');
COMMIT;

BEGIN;
INSERT INTO `RICHIESTA_RESO` VALUES
('270001','INDESIT','000002',true, true, '70'),
('270000','APPLE','000008',true,false,'70');
COMMIT;

BEGIN;
INSERT INTO `CAUSATA` VALUES
('270000','280000','281000'),
('270001','280001','281001');
COMMIT;

BEGIN;
INSERT INTO `motivazione` VALUES
('280000','minor prezzo','è stato comprato lo stesso dispositivo ma ad un prezzo minore'),
('280001','Non e come mi aspettavo','Il dispositivo non ha le caratteristiche che il cliente credeva avesse');
COMMIT;

BEGIN;
INSERT INTO `DIFETTO` VALUES
('281000','device lento','Il device ha un evidente calo di performance'),
('281001','Ammaccatura','Il device presenta un ammaccatura');
COMMIT;

BEGIN;
INSERT INTO `TEST` VALUES
('290000','controllo generale','Controllo generale del prodotto(lavatrice)'),
('290001','controllo del motore','test sul motore'),
('290002','controllo della resistenza','test sulla resistenza'),
('290003','controllo del cestello','test sul cestello'),
('290004','controllo avvolgimento','test sull avvolgimento'),
('290005','controllo cinghia','test della cinghia'),
('290006','controllo morsetti','test dei morsetti'),
('290007','controllo puleggia','test della puleggia'),
('290008','controllo albero','test dell albero'),
('290009','controllo sonda temperatura','test della sonda della temperatura'),
('290010','controllo elettrostato','test dell elettrostato'),
('290011','controllo pompa di scarico','test delle pompe di scarico');
COMMIT;

BEGIN;
INSERT INTO `PRECEDENZASUCCESSIONE` VALUES
('290000','290001'),
('290000','290002'),
('290000','290003'),
('290001','290004'),
('290001','290005'),
('290001','290008'),
('290002','290009'),
('290002','290010'),
('290001','290011'),
('290003','290006'),
('290003','290007');
COMMIT;

BEGIN;
INSERT INTO `CONTROLLO` VALUES
('270001','290000',false),
('270001','290001',false),
('270001','290004',true),
('270001','290005',true),
('270001','290011',true);
COMMIT;

BEGIN;
INSERT INTO `SMART_DEVICE` VALUES 
('SAMSUNG','000001','5.5','4','smartphone','Colore: nero',null),
('SAMSUNG','000002','5.5','4','smartphone','Colore: nero',null),
('SAMSUNG','000003','5.5','4','smartphone','Colore: bianco',null),
('SAMSUNG','000004','5.5','4','smartphone','Colore: bianco',null),
('SAMSUNG','000005','5.5','4','smartphone','Colore: oro',null),
('APPLE','000001','13','4','Notebook','Webcam: si','Colore: grigio'),
('APPLE','000002','13','4','Notebook','Webcam: si','Colore: grigio'),
('APPLE','000003','13','4','Notebook','Webcam: si','Colore: bianco'),
('APPLE','000004','13','4','Notebook','Webcam: si','Colore: bianco'),
('APPLE','000005','13','4','Notebook','Webcam: si','Colore: grigio'),
('APPLE','000006','4.5','2','smartphone','colore: bianco',null),
('APPLE','000007','4.5','2','smartphone','colore: nero',null),
('APPLE','000008','4.5','2','smartphone','colore: nero',null),
('APPLE','000009','4.5','2','smartphone','colore: nero',null);
COMMIT;

BEGIN;
INSERT INTO `ELETTRODOMESTICO` VALUES
('LG','000001','lavatrice','800','capacita cestello: 12 kg',null),
('LG','000002','lavatrice','800','capacita cestello: 12 kg',null),
('LG','000003','lavatrice','800','capacita cestello: 12 kg',null),
('LG','000004','lavatrice','800','capacita cestello: 12 kg',null),
('BOSCH','000001','forno','700','gradi max: 260','timer: si'),
('BOSCH','000002','forno','700','gradi max: 260','timer: si'),
('BOSCH','000003','forno','700','gradi max: 260','timer: si');
COMMIT;

BEGIN;
INSERT INTO `RADIO` VALUES
('SONY','000001','2500','3'),
('SONY','000002','2500','3'),
('SONY','000003','2500','3'),
('SONY','000004','2500','3');
COMMIT;

BEGIN;
INSERT INTO `UNITA_PERSA` VALUES
('APPLE','000007','010000','2020-09-22'),
('LG','000002','010001','2020-09-23');
COMMIT;

BEGIN;
INSERT INTO `LOTTO` VALUES
('1000001','5','2020-08-10','2020-08-15','concluso','0','1','storage 1','Pisa','240000'),
('1000002','5','2020-08-10','2020-08-15','concluso','0','1','storage 1','Pisa','240001'),
('1000003','4','2020-08-10',null,'in produzione','0','1','storage 2','Lucca','240001'),
('1000004','4','2020-08-10','2020-08-15','concluso','0','1','storage 2','Lucca','240001'),
('1000006','3','2020-08-10','2020-08-15','concluso','0','1','storage 3','Pisa','240000'),
('1000007','2','2020-08-10',null,'in produzione','0','1','storage 1','Pisa','240001'),
('1000008','2','2020-08-10','2020-08-15','concluso','0','1','storage 1','Pisa','240000');
COMMIT;

BEGIN;
INSERT INTO `SEDE` VALUES
('Pisa','Sede 1'),
('Lucca','Sede 2'),
('Firenze','Sede 3');
COMMIT;

BEGIN;
INSERT INTO `MAGAZZINO` VALUES
('storage 1','Pisa','smart device','200','6'),
('storage 2','Lucca','elettrodomestici','80','1'),
('storage 3','Pisa','radio','120','3');
COMMIT;

BEGIN;
INSERT INTO `CONTENUTO_CORRENTE` VALUES
('storage 1','pisa','SAMSUNG','000001'),
('storage 1','pisa','SAMSUNG','000002'),
('storage 1','pisa','SAMSUNG','000004'),
('storage 1','pisa','APPLE','000001'),
('storage 1','pisa','APPLE','000002'),
('storage 1','pisa','APPLE','000004'),
('storage 2','Lucca','BOSCH','000001'),
('storage 3','Pisa','SONY','000002'),
('storage 3','Pisa','SONY','000003'),
('storage 3','Pisa','SONY','000004');
COMMIT;

BEGIN;
INSERT INTO `CONTENUTO_STORICO` VALUES
('storage 1','Pisa','SAMSUNG','000003','2020-08-15','2020-08-25'),
('storage 1','Pisa','SAMSUNG','000005','2020-08-15','2020-08-25'),
('storage 1','Pisa','APPLE','000003','2020-08-15','2020-08-25'),
('storage 1','Pisa','APPLE','000005','2020-08-15','2020-08-25'),
('storage 1','Pisa','APPLE','000008','2020-08-15','2020-08-25'),
('storage 1','Pisa','APPLE','000009','2020-08-15','2020-08-25'),
('storage 3','Pisa','SONY','000001','2020-08-15','2020-08-25'),
('storage 2','Lucca','BOSCH','000003','2020-08-15','2020-08-25');

BEGIN;
INSERT INTO `ORGANIZZAZIONE_LINEA_PRODUZIONE` VALUES
('100001','010000','schermo','120'),
('100002','010000','schermo','120'),
('100002','010001','back','120'),
('100003','010001','lato posteriore','120'),
('100003','010002','lato anteriore','120'),
('100004','010001','lato posteriore','120'),
('100006','010000','lato posteriore','120'),
('100006','010003','lato anteriore','120'),
('100007','010002','schermo','120'),
('100008','010001','schermo','120');
COMMIT;

BEGIN;
INSERT INTO `STAZIONE` VALUES
('010000'), (010001), (010002), (010003);
COMMIT;

BEGIN;
INSERT INTO `OPERATORE` VALUES
('abcde1', 'marco', '20', '1500', '90','010000'),
('abcde2', 'luigi', '25', '1300', '95', '010000'),
('abcde3', 'lisa', '56', '1700', '110', '010001'),
('abcde4', 'francesco', '38', '1200', '80', '01002'),
('abcde5', 'chiara', '40', '1500', '100', '010003');
COMMIT;

BEGIN;
INSERT INTO `CONTROLLO_TEMPI` VALUES
('abcde1','1000001','2020-09-12','8'),
('abcde2','1000003','2020-09-12','60'),
('abcde3','1000005','2020-09-12','15'),
('abcde3','1000010','2020-09-12','18'),
('abcde4','1000012','2020-09-12','21'),
('abcde5','1000011','2020-09-12','21'),
('abcde2','1000007','2020-09-12','40'),
('abcde1','1000022','2020-09-12','17');
COMMIT;

BEGIN;
INSERT INTO `OPERAZIONE` VALUES
('1000000','avvitare','montaggio','3','cacciavite','1100000','1100002','600000','1',true),
('1000001','incollare','montaggio','10',null,'1100000','1100017','600000','2',true),
('1000002','montare schermo','montaggio','60','riscaldatore','1100004','1100003','600000','3',true),
('1000003','avvitare','montaggio','20','cacciavite','1100006','1100007','600000','1',true),
('1000004','montare scocca ','montaggio','100','cacciavite','1100013','1000001','600000','2',true),
('1000005','incollare tubi','montaggio','12',null,'1000010','1000009','600000','4',false),
('1000006','avvitare antenna','montaggio','50','cacciavite','1000013','1000016','600000','5',false),
('1000007','montare tastiera','montaggio','100',null,'1000011','1000012','600000','6',false),
('1000008','montare tastiera','montaggio','50','cacciavite','1000002','1000012','600000','1',false),
('1000009','avvitare bullone','montaggio','30','chiave','1000013','1000007','600000','2',false),
('1000010','montare ram','montaggio','30',null,'1000003','1000014','600000','1',false),
('1000011','montare1','montaggio','20',null ,'1000000','1000014','600000','3',false),
('1000012','montare2','montaggio','20',null ,'1000016','1000002','600000','3',false),
('1000013','montare3','montaggio','20',null ,'1000004','1000020','600000','4',false),
('1000014','montare4','montaggio','20',null ,'1000021','1000013','600000','1',false),
('1000015','scr+antenna','montaggio','20',null ,'1000018','1000016','600000','5',false),
('1000016','schedamadre+cpu+schermo+display','montaggio','20',null ,'1000011','1000020','600000','4',false),
('1000017','scr+schermo+display','montaggio','20',null ,'1000013','1000015','600000','4',false),
('1000018','scr+schermo+display+scocca','montaggio','20',null ,'1000032','1000013','600000','4',false),
('1000019','scr+schermo+display+scocca+antenna','montaggio','20',null ,'1000026','1000016','600000','5',false),
('1000020','scocca+scheda madre','montaggio','20',null ,'1000013','1000002','600000','6',false),
('1000021','scocca+scr','montaggio','20',null ,'1000013','1000018','600000','6',false),
('1000022','scr+antenna+schermo+display+scocca','montaggio','20',null ,'1000022','1000027','600000','2',false),
('1000023','scr+schermo+display','montaggio','20',null ,'1000033','1000014','600000','1',false);

COMMIT;

BEGIN;
INSERT INTO `PARTE` VALUES
('1100000','cpu','70','20','2','10'),
('1100001','motore+cestello','70','20','2','10'),
('1100002','scheda madre','50','50','2','5'),
('1100003','scheda madre+cpu','100','70','2','10'),
('1100004','schermo','40','20','2','5'),
('1100006','cestello','10','10','2','6'),
('1100007','motore','60','56','2','11'),
('1100008','motore+cestello','200','76','2','12'),
('1100009','tubo interno','10','10','2','1'),
('1100010','tubo esterno','10','10','2','1'),
('1100011','scheda madre+cpu+schermo','150','60','2','20'),
('1100012','tastiera','10','10','2','1'),
('1100013','scocca','50','10','2','2'),
('1100014','ram','20','10','2','5'),
('1100015','batteria','20','30','2','5'),
('1100016','antenna','12','10','2','1'),
('1100017','dissipatore','5','20','2','1'),
('1100018','scheda madre+cpu+ram','5','20','2','1'),
('1100019','scocca+scr','5','20','2','1'),
('1100020','display','5','20','2','1'),
('1100021','schermo+display','5','20','2','1'),
('1100022','schermo+display+scocca','5','20','2','1'),
('1100023','scocca+scheda madre','5','20','2','1'),
('1100024','scheda madre+antenna','5','20','2','1'),
('1100025','cpu+ram','5','20','2','1'),
('1100026','scocca+schermo+display+scr','5','20','2','1'),
('1100027','scr+antenna','5','20','2','1'),
('1100028','schermo+display+scocca+scr+antenna','5','20','2','1'),
('1100029','schermo+display+scocca+scr+batteria','5','20','2','1'),
('1100030','scr+antenna','5','20','2','1'),
('1100031','scheda madre+cpu+antenna','5','20','2','1'),
('1100032','scr+schermo+display','5','20','2','1'),
('1100033','scheda madre+cpu+schermo+display','5','20','2','1');
COMMIT;

BEGIN;
INSERT INTO `COMPOSIZIONE_PARTE` VALUES
('1000000','silicio','10'),
('1000001','ferro','50'),
('1000002','rame','20'),
('1000006','plastica','10'),
('1000010','plastica','10'),
('1000011','silicio','80'),
('1000012','plastica','10');
COMMIT;

BEGIN;
INSERT INTO `UTENSILE` VALUES
('cacciavite','ferro'),
('riscaldatore','plastica'),
('chiave','ferro');
COMMIT;

BEGIN;
INSERT INTO `ELEMENTO_DI_GIUNZIONE` VALUES
('600000');
COMMIT;

BEGIN;
INSERT INTO `PRECEDENZA_TECNOLOGICA_IMMEDIATA` VALUES
('1000000','1000013'), 
('1000000','1000012'),
('1000000','1000011'),
('1000000','1000009'),
('1000000','1000008'),
('1000000','1000007'),
('1000000','1000006'),
('1000000','1000005'), -- dopo cpu+scheda madre -> cpu+scheda madre+schermo
('1000000','1000010'), -- dopo cpu+scheda madre -> cpu+scheda madre+ram
('1000013','1000014'), -- dopo schermo+display -> schermo + display +scocca
('1000010','1000015'),  -- dopo scr -> scr+antenna
('1000015','1000021'),  -- dopo scr+antenna -> scr+antenna+scocca+schermo+display
('1000014','1000020'),  -- dopo schermo+display+scocca -> scr+antenna+scocca+schermo+display
('1000011','1000015'),
('1000000','1000016'),
('1000001','1000022'),
('1000012','1000013'),
('1000014','1000011'),
('1000010','1000009'),
('1000017','1000018'),
('1000011','1000005'),
('1000002','1000003'),
('1000001','1000006'),
('1000017','1000014'),
('1000011','1000010'),
('1000009','1000007'),
('1000009','1000018'),
('1000003','1000015'),
('1000011','1000013'),
('1000017','1000011'),
('1000021','1000007'),
('1000020','1000012'),
('1000013','1000008'),
('1000017','1000008'),
('1000010','1000007'),
('1000010','1000002'),
('1000000','1000002'),
('1000000','1000019'),
('1000008','1000016'),
('1000007','1000008'),
('1000009','1000001'),
('1000023','1000008');
COMMIT;

BEGIN;
INSERT INTO `CODICI_DI_ERRORE` VALUES
('900000','700000'),
('900001','700001'),
('900002','700002'),
('900003','700003'),
('900004','700004'),
('900005','700005'),
('900006','700006'),
('900007','700007'),
('900008','700008'),
('900009','700009');
COMMIT;

BEGIN;
INSERT INTO `GUASTO` VALUES 
('700000','ProblemaDisplay','Il display non si accende'),
('700001','ProblemaBatteria','Batteria non funziona correttamente'),
('700002','Virus','Device colpito da un virus'),
('700003','ProblemaFotocamera','La fotocamera non funziona correttamente'),
('700004','problemaTouch','Il touch non funziona'),
('700005','ProblemaMicrofono','Il microfono non funziona'),
('700006','caloPerformance','Il device è molto lento'),
('700007','ProblemaAudio','Il volume è molto basso'),
('700008','ErroreGenerico','Componente interna da cambiare'),
('700009','Surriscaldamento','Il telefono scalda molto');
COMMIT;

BEGIN;
INSERT INTO `RIMEDIO` VALUES
('800000','Riavviare il dispositivo'),
('800001','Formattare il dispositivo'),
('800002','Prenotare richiesta assistenza fisica'),
('800003','Sostituire il display'),
('800004','Chiudere tutte le applicazioni'),
('800005','Effettuare un ripristino parziale'),
('800006','Sostituire la batteria'),
('800007','Cancellare applicazioni');
COMMIT;

BEGIN;
INSERT INTO `SOLUZIONE` VALUES
('800000','700000',true,'800003'),
('800029','700000',true,'800003'),
('800001','700000',true,'800000'),
('800002','700000',true,'800003'),
('800030','700000',true,'800005'),
('800031','700000',true,'800005'),
('800003','700001',true,'800006'),
('800004','700001',true,'800006'),
('800005','700001',false,'800006'),
('800006','700001',true,'800001'),
('800007','700002',true,'800001'),
('800008','700002',true,'800001'),
('800009','700002',false,'800001'),
('800010','700002',true,'800000'),
('800011','700002',true,'800001'),
('800012','700003',true,'800002'),
('800013','700003',true,'800002'),
('800014','700003',true,'800000'),
('800015','700003',true,'800005'),
('800016','700004',true,'800003'),
('800017','700004',false,'800007'),
('800018','700005',true,'800000'),
('800019','700005',true,'800000'),
('800020','700005',true,'800004'),
('800021','700005',false,'800007'),
('800022','700006',true,'800001'),
('800023','700006',true,'800007'),
('800024','700008',true,'800002'),
('800025','700008',true,'800002'),
('800026','700008',true,'800006'),
('800027','700008',false,'800003'),
('800028','700009',true,'800001');
COMMIT;

BEGIN;
INSERT INTO `ACCOUNT` VALUES
('abc.gmail.com','123','nome del cane?','nala','marco','2020-09-12'),
('def.gmail.com','456','nome del cane?','max','riccardo','2020-09-12');
COMMIT;

BEGIN;
INSERT INTO `ORDINE` VALUES
('200000','Evaso','2020-09-29','200','2020-09-25','abc.gmail.com','300000');
COMMIT;


BEGIN;
INSERT INTO `ORDINE_RIPARAZIONI` VALUES
('210000','220000','2020-05-05','2020-05-04','250');
COMMIT;

BEGIN;
INSERT INTO `PREVENTIVO` VALUES
('220001', '230000', '2020-05-05', '6', true, '500', true);
COMMIT;

BEGIN;
INSERT INTO `SEQUENZA` VALUES
('240000','10','5','120','montaggio'),
('240001','2','3','110','smontaggio');
COMMIT;

BEGIN;
INSERT INTO `LOTTO_DI_RESI` VALUES
('250000','10','10','240001'),
('250001','3','10',null);
COMMIT;

BEGIN;
INSERT INTO `TECNICO` VALUES
('260000','15'),
('260001','25');
COMMIT;

BEGIN;
INSERT INTO `CALENDARIO` VALUES
('260000','lunedi','2020-09-20','Pisa',true,true,false,true,false),
('260000','martedi','2020-09-21','Siena',true,true,false,true,false),
('260000','mercoledi','2020-09-22',null,false,false,false,false,false),
('260000','giovedi','2020-09-23','Pisa',true,false,false,false,false),
('260000','venerdi','2020-09-24','Lucca',true,false,false,true,false),
('260001','lunedi','2020-09-20',null,false,false,false,false,false),
('260001','martedi','2020-09-21','viareggio',true,true,true,false,false),
('260001','mercoledi','2020-09-22',null,false,false,false,false,false),
('260001','giovedi','2020-09-23','lucca',false,true,false,false,true),
('260001','venerdi','2020-09-24',null,false,false,false,false,false);
COMMIT;
--------------------------------------------------------------------------------------------------------------------------------------------
 -------------------------------------------------------- VINCOLI,TRIGGER,EVENT ------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------

-- gestione costo totale parti in ordine riparazioni --  --CONTROLLATO--
DELIMITER $$

CREATE TRIGGER AggiornaCostoTotPartiRiparazione
AFTER INSERT ON COMPOSIZIONE_ORDINE
FOR EACH ROW
BEGIN 
    DECLARE costoparte int(11) default 0;
    SET costoparte= (SELECT P.Prezzo
                      FROM PARTE P
                      WHERE P.CodiceParte=NEW.Parte
                      );
   
    UPDATE ORDINE_RIPARAZIONI 
    SET CostoTotaleParti=CostoTotaleParti+costoparte
    WHERE CodiceOrdine=NEW.OrdineRiparazioni;
END $$
DELIMITER ;
     
-- gestione costo totale in Ordine --   --CONTROLLATO--
DELIMITER $$
CREATE TRIGGER AggiornaCostoTotOrdine
AFTER INSERT ON COMPOSTO
FOR EACH ROW
BEGIN
    SET @CostoProdotto=(SELECT P.Prezzo
						FROM PRODOTTO_ELETTRONICO P
                        WHERE P.Marca=NEW.Marca AND P.CodiceSeriale=NEW.CodiceSeriale
                        );
	 UPDATE ORDINE
     SET CostoTotale=CostoTotale+@CostoProdotto
     WHERE CodiceOrdine=NEW.Ordine;
END $$
DELIMITER ;

-- gestione ricevuta in secondo intervento--  --CONTROLLATO--
DELIMITER $$
CREATE TRIGGER AggiornaRicevuta
BEFORE INSERT ON SECONDO_INTERVENTO
FOR EACH ROW
BEGIN 
    SET @CostoTecnico=(SELECT T.CostoOra
					   FROM TECNICO T
                       WHERE t.CodiceTecnico=NEW.Tecnico
                       );
	SET @costoParti=(SELECT O.CostoTotaleParti
                     FROM ORDINE_RIPARAZIONI O INNER JOIN PREVENTIVO P ON O.Preventivo=P.codicePreventivo
                     WHERE P.codicePreventivo=NEW.Preventivo
                     );
	SET NEW.Ricevuta=@CostoTecnico*NEW.oreManodopera+@costoParti;
END $$
DELIMITER ;

-- gestione unita contenute in magazzino --  --CONTROLLATO--
DELIMITER $$
CREATE TRIGGER AggiornaUnitaContenuteMagazzino
BEFORE INSERT ON LOTTO
FOR EACH ROW
BEGIN 
	SET @UnitaContenuteMagazzino= (SELECT M.unitaContenute
                                  FROM MAGAZZINO M
                                  WHERE M.Nome=NEW.Magazzino AND M.Sede=NEW.sede
                                  );
	SET @CapienzaMagazzino = (SELECT M.Capienza
							 FROM MAGAZZINO M
							 WHERE M.Nome=NEW.Magazzino AND M.Sede=NEW.sede
							 );
	IF @UnitaContenuteMagazzino+NEW.numeroUnita>@CapienzaMagazzino THEN
	   SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Limite massimo magazzino superato';
       END IF;
    
    UPDATE MAGAZZINO
    SET UnitaContenute=UnitaContenute+NEW.numeroUnita
    WHERE Nome=NEW.magazzino AND Sede=NEW.sede;
END $$
DELIMITER ;
    
-- gestione tempo tot ideale in sequenza --  --CONTROLLATO--
DELIMITER $$
CREATE TRIGGER AggiornaTempoTotIdealeSequenza
AFTER INSERT ON APPLICAZIONE
FOR EACH ROW
BEGIN
   SET @TempoOperazione= (SELECT O.TempoDiEsecuzioneIdealeMin
                         FROM OPERAZIONE O
                         WHERE O.idOperazione=NEW.Operazione
                         );
   UPDATE SEQUENZA
   SET TempoTotaleIdealeMinuti=TempoTotaleIdealeMinuti+@TempoOperazione
   WHERE CodiceSequenza=NEW.Sequenza;
END $$
DELIMITER ;

-- gestione numero unita in lotto di resi --  --CONTROLLATO--
DELIMITER $$
CREATE TRIGGER AggiornaNumeroUnitaResi
AFTER INSERT ON SISTEMAZIONE
FOR EACH ROW
BEGIN
   SET @unitaLottoAttuali= (SELECT L.numeroUnita
                            FROM LOTTO_DI_RESI L
                            WHERE L.codiceLotto=NEW.lotto
                            );
   SET @sogliaSmontaggio=(SELECT L.SogliaPerLoSmontaggio
                            FROM LOTTO_DI_RESI L
                            WHERE L.codiceLotto=NEW.lotto
                            );
   IF @unitaLottoAttuali=@sogliaSmontaggio THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'La soglia per lo smontaggio di questo lotto è già stata raggiunta';
   END IF;

   UPDATE LOTTO_DI_RESI
   SET numeroUnita=numeroUnita+1
   WHERE codiceLotto=NEW.lotto;
END $$
DELIMITER ;

-- aggiornamento numero unità perse lotto --  --CONTROLLATO --
CREATE EVENT AggiornaUnitaPersa
ON SCHEDULE EVERY 1 day 
STARTS CURRENT_TIMESTAMP
DO 
    UPDATE LOTTO
    SET numeroUnitaPerse=numeroUnitaPerse+ (SELECT COUNT(*)
                                            FROM UNITA_PERSA U NATURAL JOIN PRODOTTO_ELETTRONICO P
                                            WHERE U.data=CURRENT_DATE
									        AND Codice=P.lotto
                                            );

-- vincolo una sequenza di montaggio/smontaggio non puo avere operazioni di smontaggio/montaggio --CONTROLLATO--
DELIMITER $$
CREATE TRIGGER ControlloSequenzaMontaggioSmontaggio
BEFORE INSERT ON APPLICAZIONE
FOR EACH ROW
BEGIN 
	SET @tipoSequenza=(SELECT S.montaggioSmontaggio
                       FROM SEQUENZA S
                       WHERE S.codiceSequenza=NEW.sequenza
                       );
	SET @tipoOperazione = (SELECT O.montaggioSmontaggio
                           FROM OPERAZIONE O
                           WHERE O.idOperazione=NEW.operazione
                           );
    IF @tiposequenza<>@tipoOperazione THEN 
       SIGNAL SQLSTATE '45000'
       SET MESSAGE_TEXT = 'Operazione incompatibile con la sequenza';
    END IF;
END $$
DELIMITER ;

-- vincoli sullo smontaggio (un lotto deve aver raggiunto una certa soglia e la sequenza deve essere di smontaggio)  -- CONTROLLATO --
DELIMITER $$
CREATE TRIGGER ControlloVincoliSmontaggio
BEFORE INSERT ON SMONTAGGIO
FOR EACH ROW
BEGIN 
   SET @soglia= (SELECT L.sogliaPerLoSmontaggio
                 FROM LOTTO_DI_RESI L
                 WHERE L.codiceLotto=NEW.CodiceLotto
                 );
   SET @NumeroUnita= (SELECT L.NumeroUnita
                      FROM LOTTO_DI_RESI L
                      WHERE L.codiceLotto=NEW.CodiceLotto
                      );
   SET @montaggiosmontaggio = (SELECT S.montaggioSmontaggio
                                FROM SEQUENZA S
                                WHERE S.codiceSequenza=NEW.CodiceSequenza
                                );
   IF @soglia<>@NumeroUnita OR @montaggiosmontaggio <> 'smontaggio' THEN
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Il lotto non è ancora pronto per lo smontaggio o la sequenza non è compatibile';
   END IF;
END $$
DELIMITER ;

-- vincolo: un preventivo deve essere accettato per procedere all'ordine riparazioni --CONTROLLATO--
DELIMITER && 
CREATE TRIGGER ControlloVincoloAccettazioneOrdineRiparazioni
BEFORE INSERT ON ORDINE_RIPARAZIONI
FOR EACH ROW
BEGIN 
   SET@accettato=(SELECT P.accettato
                  FROM PREVENTIVO P
                  WHERE P.codicePreventivo=NEW.preventivo
                  );
   IF @accettato=false THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Il preventivo non è stato accettato. Impossibile procedere';
   END IF;
END &&
DELIMITER ;

-- vincolo: un preventivo deve essere accettato per poter fissare un secondo intervento-- --CONTROLLATO--

DELIMITER &&
CREATE TRIGGER ControlloVincoloAccettazioneSecondoIntervento
BEFORE INSERT ON SECONDO_INTERVENTO
FOR EACH ROW
BEGIN 
   SET@accettato=(SELECT P.accettato
                  FROM PREVENTIVO P
                  WHERE P.codicePreventivo=NEW.preventivo
                  );
   IF @accettato=false THEN 
   SIGNAL SQLSTATE '45000'
   SET MESSAGE_TEXT = 'Il preventivo non è stato accettato. Impossibile procedere';
   END IF;
END &&
DELIMITER ;   

-- vincolo per la prenotazione di una richiesta assistenza fisica --
DELIMITER &&
CREATE TRIGGER VincoloPrenotazioneAssFisica
BEFORE INSERT ON RICHIESTA_ASSISTENZA_FISICA
FOR EACH ROW
BEGIN 
    SET @Citta=(SELECT C.citta
                FROM CALENDARIO_SETTIMANALE C
                WHERE C.tecnico=NEW.tecnico AND NEW.giorno=C.data
                );
	IF @Citta <> NEW.Citta AND @citta IS NOT NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Il tecnico questo giorno è gia occupato in un altra città';
    END IF;
END $$
DELIMITER ;

-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------                    
-- -------------------------------------------------------------------------- STORED PROCEDURE ---------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------------------------------------------------

-- procedure che restituisce le percentuali con cui ogni sottolivello è stato testato, utile per la politica di refurbishment --

DROP PROCEDURE IF EXISTS Percentuali_test_reso;
DELIMITER $$
CREATE PROCEDURE Percentuali_test_reso (IN _codiceReso int(11))
BEGIN
   SET @test_0 =(SELECT C.test    
                 FROM CONTROLLO C LEFT OUTER JOIN PRECEDENZASUCCESSIONE P ON C.test=P.testSuccessivo
                 WHERE P.testPrecedente IS NULL AND C.reso=_codiceReso);
                 
   WITH test_1_livello AS 
   (
   SELECT  P.testSuccessivo AS codice
	FROM TEST T INNER JOIN PRECEDENZASUCCESSIONE P ON T.codice=P.testPrecedente
    WHERE T.codice=@test_0
    ), numTotSottolivelliPerTest AS 
    (
    SELECT T.codice,COUNT(P.testSuccessivo) as numeroTotSottolivelli
    FROM test_1_livello T INNER JOIN PRECEDENZASUCCESSIONE P ON T.codice=P.testPrecedente
    GROUP BY T.codice
    ), numControlliSuiSottoLivelli AS
    (
    SELECT T.codice,COUNT(C.test) AS numSottolivelliControllati
    FROM (test_1_livello T INNER JOIN PRECEDENZASUCCESSIONE P ON T.codice=P.testPrecedente) INNER JOIN CONTROLLO C ON P.testSuccessivo=C.test
    WHERE C.Reso=_codiceReso AND C.esitoTest=true
    GROUP BY T.codice
    )
    SELECT codice,(numSottolivelliControllati/numeroTotSottolivelli)*100 AS PercentualeTestGiaEffettuati
    FROM numControlliSuiSottolivelli NATURAL JOIN numTotSottolivelliPerTest;

END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS Dati_Ordine;

DELIMITER $$

CREATE PROCEDURE Dati_Ordine (IN _codiceOrdine int(11))
BEGIN
   SELECT *
   FROM ORDINE O
   WHERE O.codiceOrdine=_codiceOrdine;
END $$

DELIMITER ;

DROP PROCEDURE IF EXISTS Aggiungere_ordine

DELIMITER $$

CREATE PROCEDURE Aggiungere_ordine (IN _account char(50), IN _codiciProdotti VARCHAR(200), IN _marcaProdotti VARCHAR(200), OUT codiceOrdine_ int(11))
BEGIN
   DECLARE codiceProdottoSingolo VARCHAR(50) DEFAULT '';
   DECLARE marcaProdottoSingolo VARCHAR(50) DEFAULT '';
   DECLARE i int(11) DEFAULT 1;
   DECLARE stato_prod char(20);
   DECLARE new_codiceOrdine int(11);
   SET SQL_SAFE_UPDATES=0;
   
   SET new_codiceOrdine=(SELECT MAX(codiceOrdine)+1
                         FROM ORDINE);
                         
   INSERT INTO ORDINE(codiceOrdine, stato, dataRecezione, costoTotale, data, account, spedizione)
   VALUES (new_codiceOrdine, 'in processazione', NULL, '0',CURRENT_DATE(), _account, NULL);
   
   SET codiceOrdine_=new_codiceOrdine;
   
   scan: LOOP
      SET codiceProdottoSingolo=(SELECT SUBSTRING(_codiciProdotti, i, 6));
      SET marcaProdottoSingolo=(SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(_marcaProdotti, ',', i), ',', -1));
     
      IF codiceProdottoSingolo='' THEN  
      LEAVE scan;
      END IF;
      
      SET stato_prod=(SELECT stato                 -- controllo disponibilita --
                 FROM PRODOTTO_ELETTRONICO
                 WHERE codiceSeriale=codiceProdottoSingolo AND marca=marcaProdottoSingolo);
	  IF stato_prod <> 'Disponibile' THEN
      SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Un prodotto inserito nell ordine non e disponibile';
  
      ELSE
      UPDATE PRODOTTO_ELETTRONICO P
      SET stato='venduto'
      WHERE P.Marca=marcaProdottoSingolo AND P.CodiceSeriale=codiceProdottoSingolo;
     
     END IF;
      
      
	  INSERT INTO COMPOSTO (Marca,CodiceSeriale,Ordine)
      VALUES (marcaProdottoSingolo, codiceProdottoSingolo, new_codiceOrdine);
      
      SET i=i+7;
      
      END LOOP;
      SET SQL_SAFE_UPDATES=1;
END $$
DELIMITER ;
 
-- iscrizione account –
DROP PROCEDURE IF EXISTS Iscrizione_account;

DELIMITER $$

CREATE PROCEDURE Iscrizione_account (IN _email char(30), IN _password char(30), IN _domandaPassword char(30), IN _rispostaPassword char(30), IN _nome char(30), IN _cognome char(30), IN _codiceFiscale char(30), IN _numeroTelefono int(20), IN _indirizzo char(30))
BEGIN
   INSERT INTO UTENTE (codiceFiscale, nome, cognome, numeroTelefono, indirizzo)
   VALUES (_codiceFiscale, _nome,_cognome, _numeroTelefono, _indirizzo);
   
   INSERT INTO ACCOUNT(Email, password, domandaPassword, rispostaPassword, Utente, DataIscrizione)
   VALUES (_email, _password, _domandaPassword, _rispostaPassword, _codiceFiscale, current_date());
   
END $$
DELIMITER ;     

-- Assunzione operaio –
DROP PROCEDURE IF EXISTS Assunzione_operatore;
DELIMITER $$
CREATE PROCEDURE Assunzione_operatore (IN _codiceFiscale char(30), IN _nome char(30), IN _eta int(11), IN _stipendio int(11), IN _stazione int(11), IN _operazione int(11), IN _tempo int(11))
BEGIN

   INSERT INTO OPERATORE (codiceFiscale, nome, eta, stipendio, stazione)
   VALUES (_codiceFiscale, _nome, _eta, _stipendio, _stazione);

   INSERT INTO CONTROLLO_TEMPI (operatore, operazione, dataverifica, tempodiesecuzioneMin)
   VALUES (_codiceFiscale, _operazione, current_date(), _tempo);
   
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS Creazione_ordine_riparazioni;
DELIMITER $$
CREATE PROCEDURE Creazione_ordine_riparazioni (IN _preventivo int(11), IN _dataConsegnaPrevista date, IN _parti VARCHAR(200))
BEGIN 
   DECLARE codiceSingolaParte VARCHAR(50) DEFAULT '';
   DECLARE i INT(11) DEFAULT 1;
   DECLARE new_codiceOrdine int(11);
   
   SET new_codiceOrdine=(SELECT MAX(CodiceOrdine)+1
                         FROM ORDINE_RIPARAZIONI);
	
    INSERT INTO ORDINE_RIPARAZIONI(CodiceOrdine, preventivo, dataConsegnaPrevista, dataConsegnaEffettiva, costoTotaleParti)
    VALUES (new_codiceOrdine, _preventivo, _dataConsegnaPrevista, NULL, '0');
	
    scan: LOOP
    SET codiceSingolaParte = (SELECT SUBSTRING(_parti, i, 7));
    
    IF codiceSingolaParte='' THEN  
      LEAVE scan;
      END IF;

    
    INSERT INTO COMPOSIZIONE_ORDINE (ordineRiparazioni, parte)
    VALUES (new_codiceOrdine, codiceSingolaParte);
    
    SET i=i+8;
    END LOOP;

END $$
DELIMITER ; 
 DROP PROCEDURE IF EXISTS Visualizza_ordine_riparazioni;
DELIMITER $$
CREATE PROCEDURE Visualizza_ordine_riparazioni (IN _codiceOrdine int(11))
BEGIN
   SELECT *
   FROM ORDINE_RIPARAZIONI
   WHERE codiceOrdine=_codiceOrdine;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS info_lotto;
DELIMITER $$
CREATE PROCEDURE info_lotto (_codiceLotto int(11))
BEGIN
   SELECT *
   FROM LOTTO L
   WHERE L.codice=_codiceLotto;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS Memorizzazione_unita_persa;
DELIMITER $$
CREATE PROCEDURE Memorizzazione_unita_persa (IN _marca char(50), IN _codiceSeriale int(11), IN _stazione int(11), IN _operazioniMancanti VARCHAR(200))
BEGIN
   DECLARE codice_singola_operazione VARCHAR(50) DEFAULT '';
   DECLARE i int(11) default 1;
   INSERT INTO UNITA_PERSA(Marca, codiceSeriale, stazione, data)
   VALUES (_marca, _codiceSeriale, _stazione, current_date());
   
   scan: LOOP
   SET codice_Singola_operazione = (SELECT SUBSTRING(_operazioniMancanti, i, 7));
   
   IF codice_Singola_Operazione='' THEN  
      LEAVE scan;
	  END IF;
   
   INSERT INTO OPERAZIONI_MANCANTI (Marca, codiceSeriale, operazione)
   VALUES (_marca, _codiceSeriale, codice_singola_operazione);
  
   SET i=i+8;
   END LOOP;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS info_prodotto_lotto;
DELIMITER $$
CREATE PROCEDURE info_prodotto_lotto (IN _marca char(50), IN _codiceSeriale int(11))
BEGIN
   SELECT *
   FROM PRODOTTO_ELETTRONICO P INNER JOIN LOTTO L ON P.lotto=L.codice
   WHERE P.marca=_marca AND p.codiceSeriale=_codiceSeriale;
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS Creazione_sequenza;
DELIMITER $$
CREATE PROCEDURE Creazione_sequenza (IN _primaOperazione int(11), OUT codiceSequenza_ int(11))
BEGIN 
   DECLARE i int(11) DEFAULT 2;
   DECLARE faccia_precedente int(11);
   DECLARE numero_rotazioni int(11) DEFAULT 0;
   DECLARE operazione_successiva int(11);
   DECLARE operazione_precedente int(11);
   DECLARE codice_Sequenza int(11);
   DECLARE montaggio_smontaggio char(30);
   
   SET codice_Sequenza=(SELECT MAX(codiceSequenza)+1
                       FROM SEQUENZA);
   SET codiceSequenza_=codice_Sequenza;
   
   SET montaggio_smontaggio = (SELECT montaggioSmontaggio
                               FROM OPERAZIONE
                               WHERE idOperazione=_primaOperazione);
   
   INSERT INTO SEQUENZA (codiceSequenza,numeroRotazioni,IndicatorePerformanceUnitaPerse, tempoTotaleIdealeMinuti, MontaggioSmontaggio)
   VALUES (codice_sequenza, '0', null, '0', montaggio_smontaggio);
   
   SET operazione_precedente=_primaOperazione;
   
   SET faccia_precedente= (SELECT faccia
						   FROM OPERAZIONE
                           WHERE IdOperazione=_primaOperazione);
                           
   INSERT INTO APPLICAZIONE (operazione, sequenza, posizioneNellaSequenza)
   VALUES (_primaOperazione, codice_sequenza, 1);
   
   scan: LOOP
   SET operazione_successiva=(SELECT O.idOperazione
                              FROM PRECEDENZA_TECNOLOGICA_IMMEDIATA P INNER JOIN OPERAZIONE O ON P.OperazioneSuccessiva=O.idOperazione
                              WHERE P.OperazionePrecedente=operazione_precedente AND O.faccia=faccia_precedente AND O.montaggioSmontaggio=montaggio_smontaggio
                              ORDER BY RAND() LIMIT 1 );
   -- caso in cui non trovo nessuna operazione sulla stessa faccia -> ne seleziono una a caso con una faccia diversa --
   IF operazione_successiva IS NULL THEN   
   SET operazione_successiva=(SELECT O.idOperazione
                              FROM PRECEDENZA_TECNOLOGICA_IMMEDIATA P INNER JOIN OPERAZIONE O ON P.OperazioneSuccessiva=O.idOperazione
                              WHERE P.OperazionePrecedente=operazione_precedente AND O.montaggioSmontaggio=montaggio_smontaggio
                              ORDER BY RAND() LIMIT 1 );
   SET numero_rotazioni=numero_rotazioni+1;
   SET faccia_precedente=(SELECT faccia
                          FROM OPERAZIONE
                          WHERE idOperazione=operazione_successiva);
	
	END IF;
   -- caso in cui non trovo nessuna operazione successiva -> sequenza finita --
   IF operazione_successiva IS NULL THEN
   LEAVE scan;
   END IF;
   
   INSERT INTO APPLICAZIONE (operazione, sequenza, posizioneNellaSequenza)
   VALUES (operazione_successiva, codice_sequenza, i);
   
    -- aggiorno gli indici --
   SET i=i+1;
   SET operazione_precedente=operazione_successiva;
   SET operazione_successiva=NULL;
   
   END LOOP;
   
   UPDATE SEQUENZA
   SET numeroRotazioni=numero_rotazioni
   WHERE codiceSequenza=codice_sequenza;
   
END $$
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------------------ DATA ANALYTICS ------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------------------------------------------------------------

-- CBR --

DROP PROCEDURE IF EXISTS CBR;
DELIMITER $$
CREATE PROCEDURE CBR (IN _marca CHAR(50), IN _codiceSeriale int(11), in _codiciErrore VARCHAR(200), IN _data DATE)
BEGIN 
   DECLARE stringa varchar (50) DEFAULT '';
   DECLARE i INT(11) DEFAULT 1;
   DECLARE codice_guasto varchar(50) DEFAULT '';

   scan: LOOP  -- registro tutti i codici di errore --
      
      SET stringa= (SELECT SUBSTRING(_codiciErrore,i,6)); -- estraggo il codice di errore dalla stringa --
      
      IF stringa='' THEN  -- istruzione di uscita, ovvero quando ho gia registrato tutti i guasti in manifestazione --
      LEAVE scan;
      END IF;
      
      SET codice_guasto= (SELECT C.Guasto
                          FROM CODICI_DI_ERRORE C
                          WHERE C.Codice=stringa);
	  INSERT INTO MANIFESTAZIONE (Marca,CodiceSeriale,Guasto,Data)
      VALUES (_marca,_codiceSeriale,codice_guasto, _data);
      
      SET i=i+7; -- riaggiorno l'indice per il guasto successivo --
   
   END LOOP;
   
   WITH Soluzioni_guasti_prodotto AS
   (
   SELECT *
   FROM SOLUZIONE S
   WHERE S.problemaRisolto=true AND S.guasto IN (SELECT M.guasto
                                               FROM MANIFESTAZIONE M
                                               WHERE M.Marca=_marca AND M.codiceSeriale=_codiceSeriale AND M.data=_data)
	) ,numero_rimedi_validi_per_guasto AS 
   (
   SELECT S.guasto, S.Rimedio, count(S.Rimedio) AS numSoluzioniValide
   FROM Soluzioni_guasti_prodotto S
   WHERE problemaRisolto=True
   GROUP BY S.guasto, S.Rimedio
  ) ,numero_totale_di_rimedi_per_guasto AS 
  (
  SELECT S.guasto, count(S.Rimedio) AS numSoluzioni
  FROM Soluzioni_guasti_prodotto S
  GROUP BY S.guasto
  ) ,rimedio_piu_probabile_per_guasto AS
  (
  SELECT N.guasto, N.Rimedio, N.numSoluzioniValide
  FROM numero_rimedi_validi_per_guasto N
  GROUP BY N.guasto
  HAVING MAX(N.numSoluzioniValide)
   ), miglior_rimedio_per_guasto AS
   (
   SELECT R.guasto, R.Rimedio, (R.numSoluzioniValide/N.numSoluzioni)*100 AS PercentualeFunzionamento
   FROM numero_totale_di_rimedi_per_guasto N NATURAL JOIN rimedio_piu_probabile_per_guasto R
   )
   
   SELECT G.nome, G.descrizione, M.Rimedio, R.descrizione, M.PercentualeFunzionamento
   FROM miglior_rimedio_per_guasto M INNER JOIN RIMEDIO R ON M.rimedio=R.codiceRimedio INNER JOIN GUASTO G ON M.guasto=G.codiceGuasto;

END $$
DELIMITER ;

-- DATA ANALYTICS: PROCESSO PRODUTTIVO --

DROP EVENT IF EXISTS Aggiornamento_Statistica_Unita_Perse;
create event Aggiornamento_Statistica_Unita_Perse   
on schedule every 1 day
do
	UPDATE SEQUENZA S
SET indicatorePerformanceUnitaPerse=
(
SELECT *
FROM(
SELECT (1-(SUM(L.NumeroUnitaPerse)/SUM(L.NumeroUnita)))*100
FROM SEQUENZA E INNER JOIN LOTTO L ON E.codiceSequenza=L.sequenza
WHERE S.codiceSequenza=E.codiceSequenza
GROUP BY E.codiceSequenza) AS X);

DROP EVENT IF EXISTS Aggiornamento_Indice_Operatori;
create event Aggiornamento_Indice_Operatori
on schedule every 1 day       
STARTS CURRENT_TIMESTAMP
do 
	update OPERATORE P
	
    set indicePerformance = (	select	F.INDICATORE
								from (	select CT.Operatore, ( avg(OPR.TempoDiEsecuzioneIdealeMin) / avg(CT.TempoDiEsecuzioneMin) *100 ) AS INDICATORE
										from OPERATORE Q INNER JOIN CONTROLLO_TEMPI CT ON Q.CodiceFiscale = CT.Operatore INNER JOIN OPERAZIONE OPR on CT.Operazione = OPR.IdOperazione
										group by CT.Operatore 
										) AS F
								where P.CodiceFiscale = F.Operatore
									)  ;
   


   














