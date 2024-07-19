/*Consulta 1*/
SELECT TOP 10 DisplayName, Locacion, Reputation
FROM Users
ORDER BY Reputation DESC;

/*Consulta 2*/
SELECT TOP 10 P.Title, U.DisplayName
FROM Posts P
INNER JOIN Users U ON P.OwnerUserId = U.Id
WHERE P.OwnerUserId IS NOT NULL;

/*Consulta 3*/
SELECT TOP 10 U.DisplayName, AVG(P.Score) AS AverageScore
FROM Posts P
INNER JOIN Users U ON P.OwnerUserId = U.Id
GROUP BY U.DisplayName;

/*Consulta 4*/
SELECT TOP 10 U.DisplayName
FROM Users U
WHERE U.Id IN (
    SELECT C.UserId
    FROM Comments C
    GROUP BY C.UserId
    HAVING COUNT(C.Id) > 100
);

/*Consulta 5*/
BEGIN TRANSACTION;

UPDATE TOP (10) Users
SET Locacion = 'Desconocido'
WHERE Locacion IS NULL OR Locacion = '';

IF @@ROWCOUNT > 0
BEGIN
    PRINT 'La actualizaci�n se realiz� correctamente para los primeros 2 registros.';
END
ELSE
BEGIN
    PRINT 'No se encontraron ubicaciones vac�as para actualizar.';
END

COMMIT TRANSACTION;

/*Consulta 6*/
BEGIN TRANSACTION;

DELETE TOP (10) C
FROM Comments C
INNER JOIN Users U ON C.UserId = U.Id
WHERE U.Reputation < 100;

DECLARE @DeletedCount INT;
SET @DeletedCount = @@ROWCOUNT;

IF @DeletedCount > 0
BEGIN
    PRINT 'Se han eliminado ' + CAST(@DeletedCount AS VARCHAR) + ' comentarios.';
END
ELSE
BEGIN
    PRINT 'No se encontraron comentarios para eliminar.';
END

COMMIT TRANSACTION;

/*Consulta 7*/
SELECT TOP 10
    u.DisplayName,
    COALESCE(p.PostCount, 0) AS TotalPosts,
    COALESCE(c.CommentCount, 0) AS TotalComments,
    COALESCE(b.BadgeCount, 0) AS TotalBadges
FROM 
    Users u
LEFT JOIN (
    SELECT 
        Id, 
        COUNT(*) AS PostCount 
    FROM 
        Posts 
    GROUP BY 
        Id
) p ON u.Id = p.Id
LEFT JOIN (
    SELECT 
        UserId, 
        COUNT(*) AS CommentCount 
    FROM 
        Comments 
    GROUP BY 
        UserId
) c ON u.Id = c.UserId
LEFT JOIN (
    SELECT 
        UserId, 
        COUNT(*) AS BadgeCount 
    FROM 
        Badges 
    GROUP BY 
        UserId
) b ON u.Id = b.UserId
ORDER BY 
    u.DisplayName;

/*Consulta 8*/
SELECT TOP 10 Title, Score
FROM Posts
ORDER BY Score DESC;

/*Consulta 9*/
SELECT TOP 5 Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC;