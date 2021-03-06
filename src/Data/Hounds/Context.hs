module Data.Hounds.Context where

import           Control.Concurrent.MVar (MVar, newMVar, readMVar, modifyMVar_)
import qualified Data.Map                as Map
import           Data.Serialize
import           Data.Word               (Word64)

import qualified Data.Hounds.Db          as Db
import qualified Data.Hounds.Hash        as Hash
import qualified Data.Hounds.Log         as Log


data Context k v = MkContext
  { contextDb          :: Db.Db
  , contextStore       :: MVar (Map.Map k v)
  , contextCount       :: MVar Word64
  , contextLog         :: MVar [Log.LogEntry k v]
  , contextWorkingRoot :: MVar Hash.Hash
  }

mkContext :: Db.Db -> Hash.Hash -> IO (Context k v)
mkContext db hash
  = MkContext db <$> newMVar Map.empty
                 <*> newMVar 0
                 <*> newMVar []
                 <*> newMVar hash

fetchStore :: Context k v -> IO (Map.Map k v)
fetchStore = readMVar . contextStore

fetchCount :: Context k v -> IO Word64
fetchCount = readMVar . contextCount

fetchLog :: (Serialize k, Serialize v) => Context k v -> IO [Log.LogEntry k v]
fetchLog = readMVar . contextLog

fetchWorkingRoot :: Context k v -> IO Hash.Hash
fetchWorkingRoot = readMVar . contextWorkingRoot

setWorkingRoot :: Context k v -> Hash.Hash -> IO ()
setWorkingRoot context = modifyMVar_ (contextWorkingRoot context) . const . pure

close :: Context k v -> IO ()
close = Db.close . contextDb
