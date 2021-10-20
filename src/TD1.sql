

CREATE OR REPLACE PROCEDURE AjouterJourneeTravail (p_codeSalarie IN Salaries.codeSalarie%TYPE, p_codeProjet IN Projets.codeProjet%TYPE,
p_dateTravail IN Travailler.dateTravail%TYPE) IS

BEGIN
    INSERT INTO Travailler VALUES (p_codeSalarie, p_dateTravail, p_codeProjet);
    UPDATE Salaries
    SET nbTotalJourneesTravail = nbTotalJourneesTravail +1
    WHERE codeSalarie = p_codeSalarie;
END;

--------------------------------------------------------------------

CALL AjouterJourneeTravail ('S2','P3','10/01/2014');

SELECT  nbTotalJourneesTRavail FROM Salaries
WHERE codeSalarie='S2';

--------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE AjouterSalarieEquipe (p_codeSalarie EtreAffecte.codeSalarie%TYPE, p_codeEquipe EtreAffecte.codeEquipe%TYPE) IS
    mycount NUMBER;
BEGIN
    SELECT COUNT(codeEquipe)  INTO mycount FROM EtreAffecte
    WHERE codeSalarie=p_codeSalarie;
    IF mycount <3 THEN
        INSERT INTO EtreAffecte (codeSalarie, codeEquipe) VALUES (p_codeSalarie, p_codeEquipe);
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Le Salarié est déjà affecté à 3 équipes, il faudrais qu il se repose un peu non ?');
    END IF;
END;