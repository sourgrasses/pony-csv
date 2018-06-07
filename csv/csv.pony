use "files"
use "itertools"

type MaybeCsvCell is (String | None)

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

primitive CsvParser
    fun parse(def: CsvFile, iter: FileLines): Array[Array[MaybeCsvCell]] =>
        var word: String ref = String(10)
        var sheet: Array[Array[MaybeCsvCell]] = Array[Array[MaybeCsvCell]](10)

        let first_line = iter.next()
        let first_row: Array[MaybeCsvCell] = Array[MaybeCsvCell](10)
        for c in first_line.values() do
            if c == 44 then
                first_row.push(word.clone())
                word.clear()
            else
                word.push(c)
            end
        end
        sheet.push(first_row)

        let size = first_row.size()
        var row: Array[MaybeCsvCell] = Array[MaybeCsvCell](size)

        for line in iter do
            for c in line.values() do
                if c == 44 then
                    row.push(word.clone())
                    word.clear()
                else
                    word.push(c)
                end
            end

            sheet.push(row.clone())
            row.clear()
            row = Array[MaybeCsvCell](size)
        end

        sheet
