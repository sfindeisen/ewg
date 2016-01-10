module Jobs (
    listJobs
) where

import Text.XML.HXT.Core

parseJobList :: (ArrowXml a) => a XmlTree String
parseJobList =
    -- When using readDocument, we must start with getChildren >>>
    -- This is not the case with xreadDoc!
    (isElem >>> hasName "jobs" >>> getChildren >>> isElem >>> hasName "job"
        `containing` (getChildren >>> hasName "status" >>> getChildren >>> (hasText $ (==) "active"))
    ) >>> getChildren >>> isElem >>> hasName "title" >>> getChildren >>> isText >>> getText

-- parse config from XML String
listJobs :: String -> String
listJobs xml =
    let html = concat $ map (\j -> "<li>" ++ j ++ "</li>\n") $ runLA (xreadDoc >>> parseJobList) xml
    in
        "<ol>\n" ++ html ++ "</ol>\n"
