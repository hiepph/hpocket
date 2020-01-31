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
  args <- getArgs
  let act = args !! 0
  case take 2 act of
    "i:" -> insert $ val act
    "q:" -> query $ val act
    _ -> error "No action"
  where
    table = "links"
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

          conn <- connectSqlite3 dbPath
          i <- prepare conn $ "INSERT INTO " ++ table ++ " (link, title, content) VALUES (?, ?, ?)"
          execute i [SqlString url, SqlString _title, SqlString _content]
          commit conn
          disconnect conn
          putStrLn url

        _ -> error $ show code

    query s = do
      conn <- connectSqlite3 dbPath
      q <- prepare conn $ "SELECT * FROM " ++ table ++ " WHERE " ++ table ++ " MATCH ?"
      execute q [SqlString s]
      r <- fetchAllRows q
      let links = map (\l -> fromSql l :: String) $ map head r
      putStrLn $ intercalate "\n" links
      disconnect conn

    trim = f. f
    f = reverse . dropWhile isSpace

    dbPath = "/home/hiepph/db/pocket.db"
