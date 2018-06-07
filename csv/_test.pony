use cli = "cli"

actor Main
    new create(env: Env) =>
        let file =
            try
                env.args(1)?
            else
                env.out.print("Expected filename argument")
                return
            end

        let f = CsvFile(file, None, false, false)
        let lines =
            try
                f.open(env)?
            else
                env.out.print("Error opening file")
                return
            end

        let sheet = CsvParser.parse(f, lines)
        for row in sheet.values() do
            for cell in row.values() do
                env.out.print(cell.string())
            end
        end
