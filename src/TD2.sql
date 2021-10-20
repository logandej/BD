8)

CREATE OR REPLACE TRIGGER tr_journeeTravail
AFTER INSERT ON Travailler
FOR EACH ROW
BEGIN
    UPDATE Salaries S
    SET nbTotalJourneesTravail = nbTotalJourneesTravail + 1
    WHERE codeSalarie = :NEW.codeSalarie;
END;

INSERT INTO Travailler VALUES('S1','10/01/2014','P1');
SELECT nbTotalJOurneesTravail FROM Salaries
WHERE codeSalarie='S1';

----------------------------------------------------------------------------
9)

CREATE OR REPLACE TRIGGER tr_equipe3max
BEFORE INSERT ON EtreAffecte
FOR EACH ROW
DECLARE
    mycount NUMBER;
BEGIN
    SELECT COUNT(codeEquipe) INTO mycount FROM EtreAffecte
    WHERE codeSalarie= :NEW.codeSalarie;
    IF mycount >= 3 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Le Salarié est déjà affecté à 3 équipes, il faudrait qu il se repose un peu non ?');
    END IF;
END;

INSERT INTO EtreAffecte VALUES('S2','E4');
SELECT * FROM EtreAffecte
WHERE codeSalarie='S2' AND codeEquipe = 'E4';

INSERT INTO EtreAffecte VALUES('S7','E4');
SELECT * FROM EtreAffecte
WHERE codeSalarie='S7' AND codeEquipe = 'E4';


---------------------------------------------------------------------------------
10)

CREATE OR REPLACE TRIGGER tr_journeeTravail2
AFTER INSERT OR DELETE OR UPDATE ON Travailler
FOR EACH ROW
BEGIN
    IF(INSERTING OR UPDATING) THEN
        UPDATE Salaries S
        SET nbTotalJourneesTravail = nbTotalJourneesTravail + 1
        WHERE codeSalarie = :NEW.codeSalarie;
    END IF;
    IF(DELETING OR UPDATING) THEN
        UPDATE Salaries S
        SET nbTotalJourneesTravail = nbTotalJourneesTravail - 1
        WHERE codeSalarie = :OLD.codeSalarie;
    END IF;
END;

--TEST
UPDATE Travailler
SET codeSalarie = 'S5'
WHERE codeSalarie = 'S1' AND dateTravail='10/01/2014';

SELECT nbTotalJourneesTravail FROM Salaries
WHERE codeSalarie = 'S1';

SELECT nbTotalJourneesTravail FROM Salaries
WHERE codeSalarie = 'S5';

DELETE Travailler
WHERE codeSAlarie = 'S5' AND dateTravail='10/01/2014';

SELECT nbTotalJourneesTravail FROM Salaries
WHERE codeSalarie = 'S5';

---------------------------------------------------------------------------
11)

CREATE OR REPLACE TRIGGER tr_equipeAffecte
AFTER INSERT ON Travailler
FOR EACH ROW
DECLARE
    nb NUMBER;
BEGIN
    SELECT Count(*) INTO nb FROM EtreAffecte EA
    JOIN Projets P ON EA.codeEquipe = P.codeEquipe
    WHERE codeSalarie = :NEW.codeSalarie AND codeProjet = :NEW.codeProjet;
    IF (nb != 0) THEN
        RAISE_APPLICATION_ERROR(-20003, 'Le salarie n est pas affecté à l equipe qui travaille sur le projet uwu');
    END IF;
END;

---------------------------------------------------------------------------
12)

CREATE VIEW Affectations (codeSalarie, nomSalarie, prenomSalarie, codeEquipe, nomEquipe) AS
SELECT S.codeSalarie, S.nomSalarie, S.prenomSalarie, E.codeEquipe, E.nomEquipe FROM Salaries S
JOIN EtreAffecte EA ON EA.codeSalarie = S.codeSalarie
JOIN Equipes E ON E.codeEquipe = EA.codeEquipe

---------------------------------------------------------------------------------
13)
CREATE OR REPLACE TRIGGER tr_Affectations
INSTEAD OF INSERT ON Affectations
FOR EACH ROW
BEGIN
    UPDATE Salaries S
    SET nbTotalJourneesTravail = nbTotalJourneesTravail + 1
    WHERE codeSalarie = :NEW.codeSalarie;
END;

