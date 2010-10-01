def parse_sudoku(filename)
	input_sudoku = Array.new(9).map! { Array.new(9).map! { 0 } }
	input_f = File.open(filename)
	for	i in 0...9
		for j in 0...9
			c = input_f.getc().chr.to_i
			if (c > 0 && c <= 9)
				input_sudoku[i][j] = c
			end
		end
		input_f.gets() # read the endline
	end
	input_f.close()
	return input_sudoku
end
