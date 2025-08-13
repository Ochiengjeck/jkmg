let us try another bible api

bible-api.com
This service provides a JSON API for retrieving Bible verses and passages, provided by Tim Morgan.

You can get the source code for this app and the open data for its database on GitHub.

There are two ways to use this service, described below.

User Input API
This is the original API, designed to take what a user types and return the matching verse(s).

https://bible-api.com/BOOK+CHAPTER:VERSE
Examples
description	link
single verse	john 3:16
abbreviated book name	jn 3:16
hyphen and comma	matt 25:31-33,46
Specifying the Translation
By default, we use the World English Bible (WEB). You can specify a different translation by providing the translation parameter in the URL. For example: /john 3:16?translation=kjv

See list of available translations below.

Single-Chapter Books
There are some books of the bible that only contain a single chapter, i.e. Obadiah, Philemon, 2 John, 3 John, and Jude. That means it can be ambiguous to request Jude 1. Do you mean the first chapter of Jude, or do you mean the first verse? This API assumes you want the first verse. This seems to be consistent with what most people expect, though it can be inconsistent when compared to other requests:

john 1 (first chapter)
jude 1 (first verse of only chapter)
This is working by design. If you want the whole chapter/book of Jude (and all single-chapter books), you can change this behavior by either setting a header or passing an extra URL parameter:

request header: X-Single-Chapter-Book-Matching: indifferent
URL parameter: single_chapter_book_matching=indifferent (example)
Parameterized API
This service provides a more precise identifier-based API as well. It requires that the translation, book, and chapter be specified exactly in the URL.

Usage: /data[/TRANSLATION_ID[/BOOK_ID[/CHAPTER]]]

TRANSLATION_ID
The translation identifier, such as "web" or "kjv".
BOOK_ID
The book id, such as "GEN" or "JHN" (they do not have to be uppercase).
CHAPTER
The chapter number.
If your browser (or an installed browser extension) supports formatting JSON, you can explore the API from /data and click the embedded URLs to navigate down to a chapter.

Some examples:

description	link
available translations	/data
books in WEB translation	/data/web
chapters in John	/data/web/JHN
verses in John 3	/data/web/JHN/3
Random Verse
There is an endpoint for getting a random verse.

Usage: /data/random[/BOOK_IDS]

BOOK_IDS
a comma-separated list of book IDs (e.g. that which you would get from here, such as "GEN" or "JHN"), or the special strings "OT" or "NT" for all Old Testament or New Testament books, respectively.
Here are some examples:

description	link
random verse	/data/web/random
random verse from specified book	/data/web/random/JHN
random verse from many books	/data/web/random/MAT,MRK,LUK,JHN
random verse from Old Testament	/data/web/random/OT
random verse from New Testament	/data/web/random/NT
Translations
Both APIs support these translations:

language	name	identifier
Cherokee	Cherokee New Testament	cherokee
Chinese	Chinese Union Version	cuv
Czech	Bible kralická	bkr
English	American Standard Version (1901)	asv
English	Bible in Basic English	bbe
English	Darby Bible	darby
English	Douay-Rheims 1899 American Edition	dra
English	King James Version	kjv
English	World English Bible	web (default)
English	Young's Literal Translation (NT only)	ylt
English (UK)	Open English Bible, Commonwealth Edition	oeb-cw
English (UK)	World English Bible, British Edition	webbe
English (US)	Open English Bible, US Edition	oeb-us
Latin	Clementine Latin Vulgate	clementine
Portuguese	João Ferreira de Almeida	almeida
Romanian	Protestant Romanian Corrected Cornilescu Version	rccv
To get more translations in this list, three things need to happen:

Find a public domain or freely-licensed bible translation. This is probably harder than you think. Freely-licensed means the license says basically you can do what you want with it without restriction. Even if you find a bible that is fully downloadable in XML or whatever format, that doesn't mean its license is permissive. You have to check that it is either so old that is in the public domain, or that the copyright owner has explicitly granted free use.
Add the XML to the open-bibles repository.
Add a language file to the bible_ref repository (if the translation is a new language).
CORS
We support Cross-Origin Resource Sharing (CORS) so you can use this API via JavaScript in a web browser.

Terms of Use
This service is free for anyone to use as long as you don't abuse my server. This service is rate limited to 15 requests every 30 seconds (based on IP address), and this may change in the future. Do not use this API to download an entire bible; instead, get the data from the source.

I make no guarantees about this service's availability, quality, or correctness. In fact, this server can and will go down from time to time because it's just a hobby for me. If you need more reliable service, remember you can grab the code and data for this site here and host it yourself!



examples

https://bible-api.com/data

gives us 

{
    "translations": [
        {
            "identifier": "cherokee",
            "name": "Cherokee New Testament",
            "language": "Cherokee",
            "language_code": "chr",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/cherokee"
        },
        {
            "identifier": "cuv",
            "name": "Chinese Union Version",
            "language": "Chinese",
            "language_code": "zh-tw",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/cuv"
        },
        {
            "identifier": "bkr",
            "name": "Bible kralická",
            "language": "Czech",
            "language_code": "cze",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/bkr"
        },
        {
            "identifier": "asv",
            "name": "American Standard Version (1901)",
            "language": "English",
            "language_code": "eng",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/asv"
        },
        {
            "identifier": "bbe",
            "name": "Bible in Basic English",
            "language": "English",
            "language_code": "eng",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/bbe"
        },
        {
            "identifier": "darby",
            "name": "Darby Bible",
            "language": "English",
            "language_code": "eng",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/darby"
        },
        {
            "identifier": "dra",
            "name": "Douay-Rheims 1899 American Edition",
            "language": "English",
            "language_code": "eng",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/dra"
        },
        {
            "identifier": "kjv",
            "name": "King James Version",
            "language": "English",
            "language_code": "eng",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/kjv"
        },
        {
            "identifier": "web",
            "name": "World English Bible",
            "language": "English",
            "language_code": "eng",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/web"
        },
        {
            "identifier": "ylt",
            "name": "Young's Literal Translation (NT only)",
            "language": "English",
            "language_code": "eng",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/ylt"
        },
        {
            "identifier": "oeb-cw",
            "name": "Open English Bible, Commonwealth Edition",
            "language": "English (UK)",
            "language_code": "eng",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/oeb-cw"
        },
        {
            "identifier": "webbe",
            "name": "World English Bible, British Edition",
            "language": "English (UK)",
            "language_code": "eng",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/webbe"
        },
        {
            "identifier": "oeb-us",
            "name": "Open English Bible, US Edition",
            "language": "English (US)",
            "language_code": "eng",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/oeb-us"
        },
        {
            "identifier": "clementine",
            "name": "Clementine Latin Vulgate",
            "language": "Latin",
            "language_code": "lat",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/clementine"
        },
        {
            "identifier": "almeida",
            "name": "João Ferreira de Almeida",
            "language": "Portuguese",
            "language_code": "por",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/almeida"
        },
        {
            "identifier": "rccv",
            "name": "Protestant Romanian Corrected Cornilescu Version",
            "language": "Romanian",
            "language_code": "ron",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/rccv"
        },
        {
            "identifier": "synodal",
            "name": "Russian Synodal Translation",
            "language": "Russian",
            "language_code": "rus",
            "license": "Public Domain",
            "url": "https://bible-api.com/data/synodal"
        }
    ]
}


https://bible-api.com/john 3:16

gives us

{
    "reference": "John 3:16",
    "verses": [
        {
            "book_id": "JHN",
            "book_name": "John",
            "chapter": 3,
            "verse": 16,
            "text": "\nFor God so loved the world, that he gave his one and only Son, that whoever believes in him should not perish, but have eternal life.\n\n"
        }
    ],
    "text": "\nFor God so loved the world, that he gave his one and only Son, that whoever believes in him should not perish, but have eternal life.\n\n",
    "translation_id": "web",
    "translation_name": "World English Bible",
    "translation_note": "Public Domain"
}




https://bible-api.com/data/kjv/JHN/3
gives me

{
    "translation": {
        "identifier": "kjv",
        "name": "King James Version",
        "language": "English",
        "language_code": "eng",
        "license": "Public Domain"
    },
    "verses": [
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 1,
            "text": "There was a man of the Pharisees, named Nicodemus, a ruler of the Jews:\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 2,
            "text": "The same came to Jesus by night, and said unto him, Rabbi, we know that thou art a teacher come from God: for no man can do these miracles that thou doest, except God be with him.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 3,
            "text": "Jesus answered and said unto him,\nVerily, verily, I say unto thee, Except a man be born again, he cannot see the kingdom of God.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 4,
            "text": "Nicodemus saith unto him, How can a man be born when he is old? can he enter the second time into his mother’s womb, and be born?\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 5,
            "text": "Jesus answered,\nVerily, verily, I say unto thee, Except a man be born of water and\nof the Spirit, he cannot enter into the kingdom of God.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 6,
            "text": "That which is born of the flesh is flesh; and that which is born of the Spirit is spirit.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 7,
            "text": "Marvel not that I said unto thee, Ye must be born again.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 8,
            "text": "The wind bloweth where it listeth, and thou hearest the sound thereof, but canst not tell whence it cometh, and whither it goeth: so is every one that is born of the Spirit.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 9,
            "text": "Nicodemus answered and said unto him, How can these things be?\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 10,
            "text": "Jesus answered and said unto him,\nArt thou a master of Israel, and knowest not these things?\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 11,
            "text": "Verily, verily, I say unto thee, We speak that we do know, and testify that we have seen; and ye receive not our witness.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 12,
            "text": "If I have told you earthly things, and ye believe not, how shall ye believe, if I tell you\nof heavenly things?\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 13,
            "text": "And no man hath ascended up to heaven, but he that came down from heaven,\neven the Son of man which is in heaven."
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 14,
            "text": "          And as Moses lifted up the serpent in the wilderness, even so must the Son of man be lifted up:\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 15,
            "text": "That whosoever believeth in him should not perish, but have eternal life."
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 16,
            "text": "          For God so loved the world, that he gave his only begotten Son, that whosoever believeth in him should not perish, but have everlasting life.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 17,
            "text": "For God sent not his Son into the world to condemn the world; but that the world through him might be saved."
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 18,
            "text": "          He that believeth on him is not condemned: but he that believeth not is condemned already, because he hath not believed in the name of the only begotten Son of God.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 19,
            "text": "And this is the condemnation, that light is come into the world, and men loved darkness rather than light, because their deeds were evil.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 20,
            "text": "For every one that doeth evil hateth the light, neither cometh to the light, lest his deeds should be reproved.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 21,
            "text": "But he that doeth truth cometh to the light, that his deeds may be made manifest, that they are wrought in God."
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 22,
            "text": "After these things came Jesus and his disciples into the land of Judaea; and there he tarried with them, and baptized.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 23,
            "text": "And John also was baptizing in Aenon near to Salim, because there was much water there: and they came, and were baptized.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 24,
            "text": "For John was not yet cast into prison.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 25,
            "text": "Then there arose a question between\nsome of John’s disciples and the Jews about purifying.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 26,
            "text": "And they came unto John, and said unto him, Rabbi, he that was with thee beyond Jordan, to whom thou barest witness, behold, the same baptizeth, and all\nmen come to him.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 27,
            "text": "John answered and said, A man can receive nothing, except it be given him from heaven.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 28,
            "text": "Ye yourselves bear me witness, that I said, I am not the Christ, but that I am sent before him.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 29,
            "text": "He that hath the bride is the bridegroom: but the friend of the bridegroom, which standeth and heareth him, rejoiceth greatly because of the bridegroom’s voice: this my joy therefore is fulfilled.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 30,
            "text": "He must increase, but I\nmust decrease.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 31,
            "text": "He that cometh from above is above all: he that is of the earth is earthly, and speaketh of the earth: he that cometh from heaven is above all.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 32,
            "text": "And what he hath seen and heard, that he testifieth; and no man receiveth his testimony.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 33,
            "text": "He that hath received his testimony hath set to his seal that God is true.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 34,
            "text": "For he whom God hath sent speaketh the words of God: for God giveth not the Spirit by measure\nunto him.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 35,
            "text": "The Father loveth the Son, and hath given all things into his hand.\n"
        },
        {
            "book_id": "JHN",
            "book": "John",
            "chapter": 3,
            "verse": 36,
            "text": "He that believeth on the Son hath everlasting life: and he that believeth not the Son shall not see life; but the wrath of God abideth on him.\n"
        }
    ]
}


https://bible-api.com/data/kjv
gives me


{
  "translation": {
    "identifier": "kjv",
    "name": "King James Version",
    "language": "English",
    "language_code": "eng",
    "license": "Public Domain"
  },
  "books": [
    {
      "id": "GEN",
      "name": "Genesis",
      "url": "https://bible-api.com/data/kjv/GEN"
    },
    {
      "id": "EXO",
      "name": "Exodus",
      "url": "https://bible-api.com/data/kjv/EXO"
    },
    {
      "id": "LEV",
      "name": "Leviticus",
      "url": "https://bible-api.com/data/kjv/LEV"
    },
    {
      "id": "NUM",
      "name": "Numbers",
      "url": "https://bible-api.com/data/kjv/NUM"
    },
    {
      "id": "DEU",
      "name": "Deuteronomy",
      "url": "https://bible-api.com/data/kjv/DEU"
    },
    {
      "id": "JOS",
      "name": "Joshua",
      "url": "https://bible-api.com/data/kjv/JOS"
    },
    {
      "id": "JDG",
      "name": "Judges",
      "url": "https://bible-api.com/data/kjv/JDG"
    },
    {
      "id": "RUT",
      "name": "Ruth",
      "url": "https://bible-api.com/data/kjv/RUT"
    },
    {
      "id": "1SA",
      "name": "1 Samuel",
      "url": "https://bible-api.com/data/kjv/1SA"
    },
    {
      "id": "2SA",
      "name": "2 Samuel",
      "url": "https://bible-api.com/data/kjv/2SA"
    },
    {
      "id": "1KI",
      "name": "1 Kings",
      "url": "https://bible-api.com/data/kjv/1KI"
    },
    {
      "id": "2KI",
      "name": "2 Kings",
      "url": "https://bible-api.com/data/kjv/2KI"
    },
    {
      "id": "1CH",
      "name": "1 Chronicles",
      "url": "https://bible-api.com/data/kjv/1CH"
    },
    {
      "id": "2CH",
      "name": "2 Chronicles",
      "url": "https://bible-api.com/data/kjv/2CH"
    },
    {
      "id": "EZR",
      "name": "Ezra",
      "url": "https://bible-api.com/data/kjv/EZR"
    },
    {
      "id": "NEH",
      "name": "Nehemiah",
      "url": "https://bible-api.com/data/kjv/NEH"
    },
    {
      "id": "EST",
      "name": "Esther",
      "url": "https://bible-api.com/data/kjv/EST"
    },
    {
      "id": "JOB",
      "name": "Job",
      "url": "https://bible-api.com/data/kjv/JOB"
    },
    {
      "id": "PSA",
      "name": "Psalms",
      "url": "https://bible-api.com/data/kjv/PSA"
    },
    {
      "id": "PRO",
      "name": "Proverbs",
      "url": "https://bible-api.com/data/kjv/PRO"
    },
    {
      "id": "ECC",
      "name": "Ecclesiastes",
      "url": "https://bible-api.com/data/kjv/ECC"
    },
    {
      "id": "SNG",
      "name": "Song of Solomon",
      "url": "https://bible-api.com/data/kjv/SNG"
    },
    {
      "id": "ISA",
      "name": "Isaiah",
      "url": "https://bible-api.com/data/kjv/ISA"
    },
    {
      "id": "JER",
      "name": "Jeremiah",
      "url": "https://bible-api.com/data/kjv/JER"
    },
    {
      "id": "LAM",
      "name": "Lamentations",
      "url": "https://bible-api.com/data/kjv/LAM"
    },
    {
      "id": "EZK",
      "name": "Ezekiel",
      "url": "https://bible-api.com/data/kjv/EZK"
    },
    {
      "id": "DAN",
      "name": "Daniel",
      "url": "https://bible-api.com/data/kjv/DAN"
    },
    {
      "id": "HOS",
      "name": "Hosea",
      "url": "https://bible-api.com/data/kjv/HOS"
    },
    {
      "id": "JOL",
      "name": "Joel",
      "url": "https://bible-api.com/data/kjv/JOL"
    },
    {
      "id": "AMO",
      "name": "Amos",
      "url": "https://bible-api.com/data/kjv/AMO"
    },
    {
      "id": "OBA",
      "name": "Obadiah",
      "url": "https://bible-api.com/data/kjv/OBA"
    },
    {
      "id": "JON",
      "name": "Jonah",
      "url": "https://bible-api.com/data/kjv/JON"
    },
    {
      "id": "MIC",
      "name": "Micah",
      "url": "https://bible-api.com/data/kjv/MIC"
    },
    {
      "id": "NAM",
      "name": "Nahum",
      "url": "https://bible-api.com/data/kjv/NAM"
    },
    {
      "id": "HAB",
      "name": "Habakkuk",
      "url": "https://bible-api.com/data/kjv/HAB"
    },
    {
      "id": "ZEP",
      "name": "Zephaniah",
      "url": "https://bible-api.com/data/kjv/ZEP"
    },
    {
      "id": "HAG",
      "name": "Haggai",
      "url": "https://bible-api.com/data/kjv/HAG"
    },
    {
      "id": "ZEC",
      "name": "Zechariah",
      "url": "https://bible-api.com/data/kjv/ZEC"
    },
    {
      "id": "MAL",
      "name": "Malachi",
      "url": "https://bible-api.com/data/kjv/MAL"
    },
    {
      "id": "MAT",
      "name": "Matthew",
      "url": "https://bible-api.com/data/kjv/MAT"
    },
    {
      "id": "MRK",
      "name": "Mark",
      "url": "https://bible-api.com/data/kjv/MRK"
    },
    {
      "id": "LUK",
      "name": "Luke",
      "url": "https://bible-api.com/data/kjv/LUK"
    },
    {
      "id": "JHN",
      "name": "John",
      "url": "https://bible-api.com/data/kjv/JHN"
    },
    {
      "id": "ACT",
      "name": "Acts",
      "url": "https://bible-api.com/data/kjv/ACT"
    },
    {
      "id": "ROM",
      "name": "Romans",
      "url": "https://bible-api.com/data/kjv/ROM"
    },
    {
      "id": "1CO",
      "name": "1 Corinthians",
      "url": "https://bible-api.com/data/kjv/1CO"
    },
    {
      "id": "2CO",
      "name": "2 Corinthians",
      "url": "https://bible-api.com/data/kjv/2CO"
    },
    {
      "id": "GAL",
      "name": "Galatians",
      "url": "https://bible-api.com/data/kjv/GAL"
    },
    {
      "id": "EPH",
      "name": "Ephesians",
      "url": "https://bible-api.com/data/kjv/EPH"
    },
    {
      "id": "PHP",
      "name": "Philippians",
      "url": "https://bible-api.com/data/kjv/PHP"
    },
    {
      "id": "COL",
      "name": "Colossians",
      "url": "https://bible-api.com/data/kjv/COL"
    },
    {
      "id": "1TH",
      "name": "1 Thessalonians",
      "url": "https://bible-api.com/data/kjv/1TH"
    },
    {
      "id": "2TH",
      "name": "2 Thessalonians",
      "url": "https://bible-api.com/data/kjv/2TH"
    },
    {
      "id": "1TI",
      "name": "1 Timothy",
      "url": "https://bible-api.com/data/kjv/1TI"
    },
    {
      "id": "2TI",
      "name": "2 Timothy",
      "url": "https://bible-api.com/data/kjv/2TI"
    },
    {
      "id": "TIT",
      "name": "Titus",
      "url": "https://bible-api.com/data/kjv/TIT"
    },
    {
      "id": "PHM",
      "name": "Philemon",
      "url": "https://bible-api.com/data/kjv/PHM"
    },
    {
      "id": "HEB",
      "name": "Hebrews",
      "url": "https://bible-api.com/data/kjv/HEB"
    },
    {
      "id": "JAS",
      "name": "James",
      "url": "https://bible-api.com/data/kjv/JAS"
    },
    {
      "id": "1PE",
      "name": "1 Peter",
      "url": "https://bible-api.com/data/kjv/1PE"
    },
    {
      "id": "2PE",
      "name": "2 Peter",
      "url": "https://bible-api.com/data/kjv/2PE"
    },
    {
      "id": "1JN",
      "name": "1 John",
      "url": "https://bible-api.com/data/kjv/1JN"
    },
    {
      "id": "2JN",
      "name": "2 John",
      "url": "https://bible-api.com/data/kjv/2JN"
    },
    {
      "id": "3JN",
      "name": "3 John",
      "url": "https://bible-api.com/data/kjv/3JN"
    },
    {
      "id": "JUD",
      "name": "Jude",
      "url": "https://bible-api.com/data/kjv/JUD"
    },
    {
      "id": "REV",
      "name": "Revelation",
      "url": "https://bible-api.com/data/kjv/REV"
    }
  ]
}


all are get methods