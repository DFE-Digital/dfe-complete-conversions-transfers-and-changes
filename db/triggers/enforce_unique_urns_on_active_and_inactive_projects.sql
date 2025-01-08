CREATE TRIGGER EnforceUniquenessOfProjectUrn
ON projects
AFTER INSERT
AS

SET NOCOUNT ON;

DECLARE @urn int;
DECLARE @inserted_state int;

SET @urn = (SELECT TOP 1
  urn
FROM inserted);
SET @inserted_state = (SELECT TOP 1
  state
FROM inserted);


IF EXISTS (
    SELECT 'URN exists on active or inactive project'
FROM projects

-- including the row just 'inserted' is there > 1 project
-- with the given URN in the active or inactive state?
WHERE urn IN (
        SELECT urn
  FROM projects
  WHERE urn = @urn
    AND state IN (0, 4)
  GROUP BY urn
  HAVING COUNT(*) > 1
    )

  -- and is that just 'inserted' record in the inactive or active state?
  AND @inserted_state IN (0, 4)
)

-- if YES, then raise an error and rollback this insertion
BEGIN
  RAISERROR ('Project URN in use', 16, 1);
  ROLLBACK TRANSACTION;
END
