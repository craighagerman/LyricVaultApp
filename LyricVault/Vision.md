#  Vision


## Import / Add songs to Core Data DB
Options:
1. write (or copy/paste)
    - I don't like this in general. I personally would not manually TYPE any songs in on an iPhone
2. import md files from Cloud (Dropbox, Google)
    - I like this idea best FOR ME. I already have lyrics in text docs locally
    - this is also the format I'd like to EXPORT to. 
3. use Genius API to find and fetch lyrics
    - might have issues getting approved by Apple.
    - maybe alternately OK to make my OWN API ... which then calls Genius? (and others)


## Views
1. Settings
2. Vault
    2.1. Library
        - master list of all songs
    2.2. Set Lists
        - list of all set lists. Tap on one ...
        - ordered list of songs in the set list, incl useful metatdata (key, bpm, etc) 
3. Import from Cloud
    3.1 Import from Dropbox
        - sync with Dropbox (if not done, otherwise hide)
        Option 1:
            - click "sync" and import all md/txt files in the Dropbox app directory
        Option 2:
            - display list of all files in the Dropbox app directory...
            - will guess and indicate which files have already been synced
            - can select files to download, and then click to download and import songs to DB 


## Persisted Data (Core Data)
Need to store:
- all songs (metadata + lyrics)
- libraries (collections of songs, albums of songs)
- song lists (names only)
- song list -> song association

MVP version needs tables for:
- songs (all songs: song id, metadata..., lyrics)
    - one-to-many (songs -> setlists)
- set list names (name-to-id mapping: setlist id, setlist name)
- set lists (setlist id, song id, order)

Song Table
- id (PK)
- metadata...
- lyrics

SetlistName Table
- setlist id (PK)
- setlist name

Setlist Table
- id (PK)
- setlist id (FK)
- song id (FK)


------------------------------------------------------------------------------------------

xcdatamodel entities
- Setlist
    - name
    - setlistid
    - song
- Songs
    - songid
    - artist
    - title
    - etc ... 




