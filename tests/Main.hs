module Main (main) where

import           Test.Tasty                          (TestTree, defaultMain,
                                                      testGroup)

import           Data.Hounds.Db.Properties           (dbProperties)
import           Data.Hounds.Hash.Properties         (hashProperties)
import           Data.Hounds.Hash.Tests              (hashTests)
import           Data.Hounds.PointerBlock.Properties (pointerBlockProperties)
import           Data.Hounds.PointerBlock.Tests      (pointerBlockTests)
import           Data.Hounds.Store.Tests             (storeTests)
import           Data.Hounds.Trie.Properties         (trieProperties)
import           Data.Hounds.Trie.Tests              (trieTests)


props :: [TestTree]
props = [dbProperties, hashProperties, pointerBlockProperties, trieProperties]

units :: [TestTree]
units = [hashTests, pointerBlockTests, storeTests, trieTests]

tests :: TestTree
tests = testGroup "Tests" [testGroup "Property tests" props, testGroup "Unit tests" units]

main :: IO ()
main = defaultMain tests
