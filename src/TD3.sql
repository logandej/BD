SET TIMING ON;
SET AUTOTRACE ON;

SELECT sexeClient, villeClient FROM CLients
WHERE nomClient='Palleja';

----------------------------3
----------------------------3a

SET TIMING ON;
SET AUTOTRACE ON;

SELECT * FROM Clients
WHERE idClient=1000;

------------------------------3b

SET TIMING ON;
SET AUTOTRACE ON;

SELECT /*+ no_index(Clients pk_Clients)*/ * FROM Clients
WHERE idClient=1000;

------------------------------3c

SET TIMING ON;
SET AUTOTRACE ON;
SET AUTOTRACE TRACEONLY;

SELECT /*+ index(Clients pk_Clients)*/ * FROM Clients
WHERE idClient!=1000;

------------------------------3d

SET TIMING ON;
SET AUTOTRACE ON;
SET AUTOTRACE TRACEONLY;

SELECT * FROM Commandes
WHERE idCommande >=60000;

------------------------------

SET TIMING ON;
SET AUTOTRACE ON;
SET AUTOTRACE TRACEONLY;

SELECT * FROM Commandes
WHERE idCommande >=90000;

------------------------------4
------------------------------4a,b

SET TIMING ON;
SET AUTOTRACE ON;

SELECT * FROM CLients
WHERE nomClient = 'Claude';

------------------------------4c

CREATE INDEX idx_Clients_nomClient ON Clients(nomClient);

SET TIMING ON;
SET AUTOTRACE ON;

SELECT * FROM CLients
WHERE nomClient = 'Claude';

------------------------------5
------------------------------5a

UPDATE Commandes
SET montantCommande = montantCommande + 10;
SELECT * FROM Commandes;

------------------------------5b

CREATE INDEX idx_Commandes_montantCommande ON Commandes(montantCommande);

------------------------------5c

UPDATE Commandes
SET montantCommande = montantCommande - 10;
SELECT * FROM Commandes;

------------------------------6
------------------------------6a

SELECT * FROM Commandes
WHERE (montantCommande/3)>3500;

------------------------------6b

SELECT * FROM Commandes
WHERE montantCommande>3500*3;

------------------------------7
------------------------------7a

SELECT * FROM Clients
WHERE villeClient = 'Marseille' AND prenomClient='Pierre';

------------------------------7b

CREATE INDEX idx_Clients_prenomClient ON Clients(prenomClient);
CREATE INDEX idx_Clients_villeClient ON Clients(villeClient);

SELECT * FROM Clients
WHERE villeClient = 'Marseille' AND prenomClient='Pierre';

------------------------------7c

DROP INDEX idx_Clients_prenomClient;
DROP INDEX idx_Clients_villeClient;

CREATE INDEX idx_Clients_prenomVille ON Clients(prenomClient,villeClient);

------------------------------7d

SELECT * FROM Clients
WHERE prenomClient='Xavier';

------------------------------7e

SELECT * FROM Clients
WHERE villeClient='Montpellier';

------------------------------7f

SELECT villeClient, teleĥoneClient FROM Clients
WHERE prenomClient='Xavier';

------------------------------8
------------------------------8a

SELECT * FROM Commandes
WHERE dateCommande IS NULL

------------------------------8b

CREATE INDEX idx_Commandes_dateCommande ON Commandes(dateCommande);

------------------------------8c

SELECT /*+ index(Commandes idx_Commandes_dateCommande)*/* FROM Commandes
WHERE dateCommande IS NULL
