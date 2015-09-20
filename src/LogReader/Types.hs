{-# LANGUAGE DeriveGeneric, OverloadedStrings  #-}
module LogReader.Types where

import Data.Aeson
import Data.Text (Text)
import GHC.Generics
import TypeCount.Types (Answer, Attempts)

-- Change this to type your plugin uses.
type LogItem = LogLine

type Name = FilePath
type Path = FilePath

data Exercise = Exercise
    { eName  :: Text
    , eTasks :: [Task]
    } deriving (Show)

data Task = Task
    { tNAme  :: Text
    , tUsers :: [User]
    } deriving (Show)

data User = User
    { uId   :: Text
    , uLogs :: [Log]
    } deriving (Show)

data Log = Log
    { lTime :: Text
    , lLog  :: LogItem
    } deriving (Show)



-- Because of incorrect serialization in TypeCount plugin
-- Request had to be redefined here.
data LogLine = LogLine
    { lBefore  :: Attempts
    , lAfter   :: Attempts
    , lRequest :: Request
    } deriving (Generic, Show)

data Request = Request
    { rAnswer :: Answer
    , rReset  :: Bool
    } deriving (Show, Generic)

instance ToJSON LogLine
instance FromJSON LogLine

instance ToJSON Request
instance FromJSON Request
