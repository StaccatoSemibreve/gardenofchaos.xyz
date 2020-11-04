{-# LANGUAGE OverloadedStrings, ExtendedDefaultRules #-}

import Data.Char
import Text.Printf
import qualified Data.Text as T
import qualified Data.Text.IO as IO
import CMarkGFM (optUnsafe, extStrikethrough, extTable, extTaskList, commonmarkToHtml)
import Lucid
import Data.List (isSuffixOf, zip4)
import System.FilePath (makeValid)
import System.Directory (listDirectory)
import Formatting (sformat, stext, shown, (%))

urlEncode :: T.Text -> T.Text
urlEncode = T.foldl (\text c -> text `T.append` (charEncode c)) T.empty
    where
        charEncode c
            | c == ' '                                                                              = "+"
            | Data.Char.isAlphaNum c || c == '-' || c == '.' || c == '_' || c == '~' || c == '\''   = T.singleton c
            | otherwise                                                                             = T.pack $ Text.Printf.printf "%%%02X" c

printer :: [(T.Text, [[T.Text]])] -> T.Text -> [T.Text] -> T.Text
printer _ "ruleset-list" (name:desc:"":[]) = sformat ("* <a name=\"" % stext % "\">**[" % stext % ":](#" % stext % ")** " % stext % "</a>") (urlEncode name) name (urlEncode name) desc
printer _ "ruleset-list" (name:desc:source:[]) = sformat ("* <a name=\"" % stext % "\">**[" % stext % ":](#" % stext % ")** " % stext % " [Source: " % stext % "]</a>") (urlEncode name) name (urlEncode name) desc source

printer _ "format-list" (name:desc:"":[]) = sformat ("* <a name=\"" % stext % "\">**[" % stext % ":](#" % stext % ")** " % stext % "</a>") (urlEncode name) name (urlEncode name) desc
printer _ "format-list" (name:desc:source:[]) = sformat ("* <a name=\"" % stext % "\">**[" % stext % ":](#" % stext % ")** " % stext % " [Source: " % stext % "]</a>") (urlEncode name) name (urlEncode name) desc source

printer csvs "index-info" (name:desc:datetime:[]) = sformat ("**" % stext % "** (" % stext % ")\n> " % stext % "\n\n" % stext) name desc formatDesc datetime
    where
        formatDesc = case formatDetails!!1 of
                          "" -> sformat stext (formatDetails!!0)
                          _ -> sformat (stext % " [Source: " % stext % "]") (formatDetails!!0) (formatDetails!!1)
                    where
                        formatDetails = maybe (error "format missing") id . lookup name . map (\item -> (head item, tail item)) . maybe (error "formats.csv missing") id . lookup "formats" $ csvs

printer _ "charicon-teambattle" (name:_) = sformat ("<image src=\"media/" % stext % ".png\" alt=\"" % stext % "\" id=\"" % stext % "\" class=\"icon\" />") name name name
printer _ "charicon-charselect1" (name:_) = sformat ("<image class=\"icon\" style=\"grid-area:" % stext % ";\" src=\"media/" % stext % ".png\" alt=\"" % stext % "\" /><a href=\"javascript:void(0);\" style=\"grid-area:" % stext % ";\" title=\"Add " % stext % " to Team 1.\" onclick='addChar(\"" % stext % "\",1)'><image class=\"overlay_char\" src=\"media/plus.svg\" /></a>") name name name name name name
printer _ "charicon-charselect2" (name:_) = sformat ("<image class=\"icon\" style=\"grid-area:" % stext % ";\" src=\"media/" % stext % ".png\" alt=\"" % stext % "\" /><a href=\"javascript:void(0);\" style=\"grid-area:" % stext % ";\" title=\"Add " % stext % " to Team 2.\" onclick='addChar(\"" % stext % "\",2)'><image class=\"overlay_char\" src=\"media/plus.svg\" /></a>") name name name name name name

printer _ "presets1team1" (name:svg:alt:flavour:code:"minus":[]) = sformat ("<image class=\"icon\" style=\"grid-area:" % stext % ";\" src=\"media/" % stext % "\" alt=\"" % stext % "\" /><a href=\"javascript:void(0);\" style=\"grid-area:" % stext % ";\" title=\"" % stext % "\" onclick='" % stext % "'><image class=\"overlay_char\" src=\"media/minus.svg\" style=\"background-color:red\" /></a>") name svg alt name (T.replace "\\team" "1" flavour) (T.replace "\\team" "1" code)
printer _ "presets1team1" (name:svg:alt:flavour:code:"plus":[]) = sformat ("<image class=\"icon\" style=\"grid-area:" % stext % ";\" src=\"media/" % stext % "\" alt=\"" % stext % "\" /><a href=\"javascript:void(0);\" style=\"grid-area:" % stext % ";\" title=\"" % stext % "\" onclick='" % stext % "'><image class=\"overlay_char\" src=\"media/plus.svg\"/></a>") name svg alt name (T.replace "\\team" "1" flavour) (T.replace "\\team" "1" code)
printer _ "presets1team2" (name:svg:alt:flavour:code:"minus":[]) = sformat ("<image class=\"icon\" style=\"grid-area:" % stext % ";\" src=\"media/" % stext % "\" alt=\"" % stext % "\" /><a href=\"javascript:void(0);\" style=\"grid-area:" % stext % ";\" title=\"" % stext % "\" onclick='" % stext % "'><image class=\"overlay_char\" src=\"media/minus.svg\" style=\"background-color:red\" /></a>") name svg alt name (T.replace "\\team" "2" flavour) (T.replace "\\team" "2" code)
printer _ "presets1team2" (name:svg:alt:flavour:code:"plus":[]) = sformat ("<image class=\"icon\" style=\"grid-area:" % stext % ";\" src=\"media/" % stext % "\" alt=\"" % stext % "\" /><a href=\"javascript:void(0);\" style=\"grid-area:" % stext % ";\" title=\"" % stext % "\" onclick='" % stext % "'><image class=\"overlay_char\" src=\"media/plus.svg\"/></a>") name svg alt name (T.replace "\\team" "2" flavour) (T.replace "\\team" "2" code)

printer _ "tournament-archive" (name:desc:ident:video:bracket:"both":[]) = sformat ("<li><strong><a href=\"https://www.youtube.com/watch?v=" % stext % "\">" % stext % ":</a></strong> " % stext % "<br>\n<button onclick=\'addArchive(this, \"" % stext % "\", \"https://www.youtube.com/embed/" % stext % "\", \"https://challonge.com/" % stext % "/module\"\'>Watch Archive (will load external content!)</button></li>") video name desc ident video bracket
printer _ "tournament-archive" (name:desc:ident:bracket:"bracket":[]) = sformat ("<li><strong>" % stext % ":</strong> " % stext % "<br>\n<button onclick=\'addBracket(this, \"" % stext % "\", \"https://challonge.com/" % stext % "\")\'>View Bracket (will load external content!)</button></li>") name desc ident bracket
printer _ "tournament-archive" (name:desc:ident:video:"video":[]) = sformat ("<li><strong><a href=\"" % stext % "\">" % stext % ":</a></strong> " % stext % "<br>\n<button onclick=\'addMatch(this, \"" % stext % "\", \"https://www.youtube.com/embed/" % stext % "\")\'>Watch Match (will load external content!)</button></li>") video name desc ident video
printer _ "tournament-archive" (name:desc:"skipped":[]) = sformat ("<li><strong>" % stext % ":</strong> " % stext % "</li>") name desc

printer _ _ _ = ""

-- 				<button onclick='addBracket(this, "gocu", "https://challonge.com/FSGardenofChaosUpdate/module")'>View Bracket (will load external content!)</button></li>
-- 				<li><strong><a>The Big Update Tournament:</a></strong> A 9-player Battle of Flagstone style tournament held on the 23rd of July 2020, won by <span class="spoiler">Darkness, EmiSocks, Mozzarella, and ThyPirateKing</span>!<br>

printerOneliner :: [(T.Text, [[T.Text]])] -> T.Text -> [[T.Text]] -> T.Text
printerOneliner _ "JsArrayHead" formats = do
    collect . map (esc . head) $ formats
    where
        collect :: [T.Text] -> T.Text
        collect [] = ""
        collect items = "'" `T.append` (collectR items) where
            collectR :: [T.Text] -> T.Text
            collectR [] = ""
            collectR (t:[]) = t `T.append` "'"
            collectR (t:ts) = t `T.append` "', '" `T.append` (collectR ts)
        
        esc :: T.Text -> T.Text
        esc = T.foldl (\text c -> text `T.append` (charEncode c)) T.empty
            where
                charEncode c
                    | c == '\''                                                                              = "\\'"
                    | otherwise                                                                             = T.singleton c
printerOneliner _ "JsOptionsHead" formats = "\'" `T.append` (foldl T.append "" . map (uncurry . sformat $ ("<option value=\"" % stext % "\">" % stext % "</option>")) . map (\x -> (x,x)) . map head $ formats) `T.append` "\'"

printerOneliner _ _ _ = ""
    

pageMarkdown :: Html () -> T.Text -> T.Text -> Html ()
pageMarkdown navbar title markdown = doctypehtml_ $ do
    head_ $ do
        title_ (toHtml title)
        meta_ [charset_ "utf-8"]
        link_ [rel_ "icon", type_ "image/png", href_ "FSgardenOfChao-196x196.png", sizes_ "196x196"]
        link_ [rel_ "stylesheet", href_ "markdown-style.css"]
        link_ [rel_ "stylesheet", href_ "navbar-style.css"]
    body_ $ do
        navbar
        div_ [id_ "center-div"] $ do
            Lucid.toHtmlRaw $ commonmarkToHtml [optUnsafe] [extStrikethrough, extTable, extTaskList] markdown

pageNonStatic :: Html () -> T.Text -> T.Text -> T.Text -> T.Text -> Html ()
pageNonStatic navbar title style body script = doctypehtml_ $ do
    head_ $ do
        title_ (toHtml title)
        meta_ [charset_ "utf-8"]
        link_ [rel_ "icon", type_ "image/png", href_ "FSgardenOfChao-196x196.png", sizes_ "196x196"]
        link_ [rel_ "stylesheet", href_ "navbar-style.css"]
        style_ style
    body_ $ do
        navbar
        (toHtmlRaw body)
    script_ script
    

pageToFile :: T.Text -> T.Text -> Html () -> IO ()
pageToFile filename title page = do
    do putStrLn $ "Page: " ++ (show title) ++ " → " ++ (show filename)
    renderToFile (T.unpack filename) page

main :: IO ()
main = do
    csvs <- getCsvs
    do putStrLn $ "CSVs: " ++ (show $ map fst csvs)
    do putStrLn $ "Formats: " ++ (show . map head . maybe (error "aaa") id . lookup "formats" $ csvs)
    let navbar = maybe (error "navbar .csv missing, can't make pages without being told about the navbar!") pageNavbar $ lookup "navbar" csvs
    let pages = maybe (error "pages.csv missing, can't make pages without being told how to!") id $ lookup "pages" csvs
    do putStrLn $ "Pages: " ++ (show $ map head pages)
    
    markdowns <- getMarks csvs pages
    do mapM_ (\(html:title:md:[]) -> pageToFile html title . pageMarkdown navbar title $ md) markdowns
    
    scripts <- getScripts csvs pages
    do mapM_ (\(html:title:css:body:script:[]) -> pageToFile html title . pageNonStatic navbar title css body $ script) scripts
    
    do putStrLn ""
    do putStrLn "All done, now remember to do the announcements by editing the svg with a text editor (just ctrl-f the different bits of text, maybe shuffle some line spacing about if needed) and export at 1000px wide using inkscape, commit it to git, and push that commit!"
    putStrLn "Send Leontes the big announcement image, and send safety_man the small one!"
    
    where
        -- get all csv files from the editable/csv directory, in the form of a list of pairs of the name of each csv, and the corresponding contents of that csv
        getCsvs :: IO [(T.Text, [[T.Text]])]
        getCsvs = do
            -- all files in the csv directory, no filtering yet
            directory <- listDirectory $ makeValid "editable/csv"
            -- those files, filtered to only csv files just in case
            let csvFiles = filter (".csv" `isSuffixOf`) directory
            -- the text inside those files
            csvContents <- mapM IO.readFile . map ("editable/csv/" ++) $ csvFiles
            -- [csv file, [[contents properly parsed]]
            return [ (maybe (error "impossible1") id . T.stripSuffix ".csv" . T.pack $ f, map (T.split (== '|')) $ T.lines c) | (f, c) <- zip csvFiles csvContents ]
        
        -- from pages.csv, return an io list of all the markdown pages from the csv, plus their md file contents (after processing)
        -- [html file, title, markdown]
        getMarks :: [(T.Text, [[T.Text]])] -> [[T.Text]] -> IO [[T.Text]]
        getMarks csvs pages = do
            -- all "markdown" csv entries, minus the last entry
            let markdownsToGet = map init . filter (\entry -> last entry == "markdown") $ pages
            -- all associated files
            files <- mapM IO.readFile . map (makeValid . T.unpack . last) $ markdownsToGet
            -- the original csv entries, minus the last 2 entries, plus the md file contents
            return [ (init a) ++ [process csvs b] | (a, b) <- zip markdownsToGet files ]
        
        -- [html file, title, css, body, script]
        getScripts :: [(T.Text, [[T.Text]])] -> [[T.Text]] -> IO [[T.Text]]
        getScripts csvs pages = do
            let scriptsToGet = map init . filter (\entry -> last entry == "script") $ pages
            filesCss <- mapM IO.readFile . map (makeValid . T.unpack . (!!2)) $ scriptsToGet
            filesBody <- mapM IO.readFile . map (makeValid . T.unpack . (!!3)) $ scriptsToGet
            filesScript <- mapM IO.readFile . map (makeValid . T.unpack . (!!4)) $ scriptsToGet
            return [ (init . init . init $ a) ++ [process csvs b] ++ [process csvs c] ++ [process csvs d] | (a, b, c, d) <- zip4 scriptsToGet filesCss filesBody filesScript ]
            
        -- go through a file, replace all things of the form "!!!csv|parser" with that csv read line-by-line by that parser, and all things of the form "!!!csv||parser" with that csv read in one line by that parser
        process :: [(T.Text, [[T.Text]])] -> T.Text -> T.Text
        process csvs mark = T.unlines [ parse line | line <- T.lines mark ]
            where
                items :: T.Text -> [[T.Text]]
                items csv = maybe (error $ "missing csv " ++ (show csv)) id (lookup csv csvs)
                parse :: T.Text -> T.Text
                parse line
                    | "!!!" `T.isPrefixOf` line = do
                        let splitLine = T.split (== '|') . maybe (error "impossible") id . T.stripPrefix "!!!" $ line
                        case (length splitLine) of
                            2 -> T.unlines . map (printer csvs . last $ splitLine) . items . head $ splitLine
                            3 -> printerOneliner csvs (last splitLine) (items . head $ splitLine)
                    | otherwise = line

        pageNavbar :: [[T.Text]] -> Html ()
        pageNavbar items = do
            header_ [class_ "navbar-div"] $ do
                mapM_ navbarItem items
            where
                navbarItem :: [T.Text] -> Html ()
                navbarItem ("icon":name:desc:pos:url:iconId:iconSrc:iconAlt:[]) = div_ [class_ " navbar-item-container", class_ pos] $ do
                    a_ [href_ url, class_ "navbar-item", title_ desc] $ do
                        div_ [class_ " navbar-item-container", class_ pos] $ do
                            img_ [id_ iconId, class_ "navbar-icon", src_ iconSrc, alt_ iconAlt]
                            span_ [class_ "navbar-item"] $ toHtml name
                navbarItem ("text":name:desc:pos:url:[]) = div_ [class_ " navbar-item-container", class_ pos] $ do
                    a_ [href_ url, class_ "navbar-item", title_ desc] $ do
                        div_ [class_ " navbar-item-container", class_ pos] $ do
                            div_ [class_ "navbar-item"] $ toHtml name
                navbarItem _ = do
                    error "invalid navbar item"
