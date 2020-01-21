module Main where

import Data.List
import Data.Char
import Network.Curl
import Text.XML.HXT.Core
import Text.HandsomeSoup
import Control.Exception
import Database.HDBC.Sqlite3 (connectSqlite3)
import Database.HDBC
import System.Environment


main = do
  -- i:https://google.com
  -- q:haskell
  act <- getLine
  case take 2 act of
    "i:" -> insert $ val act
    "q:" -> query $ val act
    _ -> error "No action"
  where
    val = trim . drop 2
    insert url = do
      (code, html) <- curlGetString url []
      case code of
        CurlOK -> do
          let doc = readString [withParseHTML yes, withWarnings no] html
          title <- runX $ doc >>> css "title" //> getText
          content <- runX $ doc >>> css "body" //> getText

          let _title = head title
          let _content =  intercalate "" content

          conn <- connectSqlite3 "pocket.db"
          i <- prepare conn "INSERT INTO pocket (title, content) VALUES (?, ?)"
          execute i [toSql _title, toSql _content]
          commit conn
          disconnect conn

        _ -> error $ show code

    query s = do
      conn <- connectSqlite3 "pocket.db"
      q <- prepare conn "SELECT * FROM pocket WHERE pocket MATCH ?"
      execute q [SqlString s]
      r <- fetchAllRows q
      print r
      disconnect conn

    trim = f. f
    f = reverse . dropWhile isSpace
