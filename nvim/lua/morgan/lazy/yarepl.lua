return { 'milanglacier/yarepl.nvim', 

  --config = true 
  config = function()
    local opts = {metas = {
              --{"ssh", "-t", "morgan@fractal", "uv",
              --"--project",  "/home/morgan/Projects/MMZ/",
              --"--directory", "/home/morgan/Projects/MMZ/",
              --"run", "ipython", "--no-autoindent" },
      ipythonfractal = {
        cmd = "ssh -t morgan@fractal uv --directory /home/morgan/Projects/MMZ/ --project /home/morgan/Projects/MMZ/ run ipython --no-autoindent",
        formatter = 'bracketed_pasting', source_syntax = 'ipython' },
    }
    }
		require('yarepl').setup(opts)
	end

}
