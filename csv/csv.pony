use "collections"
use "files"
use "itertools"

type CsvCell[T: Any iso] is (T | None)

type MaybeDelimiter is (U8 | None)

class CsvFile
    let filename: String
    let delimiter: MaybeDelimiter
    let headers: Bool
    let quoted: Bool

    new create(filename': String, delimiter': MaybeDelimiter = None, headers': Bool, quoted': Bool) =>
        filename = filename'
        delimiter = delimiter'
        headers = headers'
        quoted = quoted'

    fun open(env: Env): FileLines ? =>
        let path = FilePath(env.root as AmbientAuth, filename)?
        match OpenFile(path)
        | let file: File =>
            FileLines(file)
        else
            error
        end

//actor CsvParser
//    be parse_line(line: String): Array[CsvCell] =>
