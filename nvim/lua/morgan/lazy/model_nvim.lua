--local ollama = require("model.providers.ollama")

--local openai_compat_url = 'http://127.0.0.1:11434/v1/'
--local openai_compat_url = 'http://mesh:11434/v1/'
local openai_compat_url = 'http://fractal:12500/v1/' -- the arbiter front door
local function input_if_selection(input, context)
  return context.selection and input or ''
end

local function code_replace_fewshot(input, context)
  local prompts = require('model.util.prompts')
  local surrounding_text = prompts.limit_before_after(context, 30)

  local content = 'The code:\n```\n'
    .. surrounding_text.before
    .. '<@@>'
    .. surrounding_text.after
    .. '\n```\n'

  if context.selection then -- we only use input if we have a visual selection
    content = content .. '\n\nExisting text at <@@>:\n```' .. input .. '```\n'
  end

  if #context.args > 0 then
    content = content .. '\nInstruction: ' .. context.args
  end

  local messages = {
    {
      role = 'user',
      content = content,
    },
  }

  return {
    instruction = 'You are an expert programmer. You are given a snippet of code which includes the symbol <@@>. Complete the correct code that should replace the <@@> symbol given the content. Only respond with the code that should replace the symbol <@@>. If you include any other code, the program will fail to compile and the user will be very sad.',
    fewshot = {
      {
        role = 'user',
        content = 'The code:\n```\nfunction greet(name) { console.log("Hello " <@@>) }\n```\n\nExisting text at <@@>: `+ nme`',
      },
      {
        role = 'assistant',
        content = '+ name',
      },
    },
    messages = messages,
  }
end

--local starters = require("model.prompts.starters")
--local code_replace_fewshot = starters.code_replace_fewshot
--local extract = require("model.prompts.extract")

return {
  'gsuuon/model.nvim',

  -- Don't need these if lazy = false
  cmd = { 'M', 'Model', 'Mchat' },
  init = function()
    vim.filetype.add({
      extension = {
        mchat = 'mchat',
      }
    })
  end,
  ft = 'mchat',

  lazy=false,
  keys = {
    {'<C-m>d', ':Mdelete<cr>', mode = 'n'},
    {'<C-m>s', ':Mselect<cr>', mode = 'n'},
    --{'<C-m><space>', ':Mchat<cr>', mode = 'n' }
    {'<C-m>c', ':Mchat<cr>', mode = 'n' },
    {'<C-m>m', ':M<cr>', mode = 'n' },
  },


  config = function(_, opts)
    --require("model.providers.openai").initialize({
    --  model = 'qwen2.5-coder:14b-instruct-q4_K_M'
    --})
    require("model").setup(opts)
  end,


  opts = function()
    return {
      -- - -
      -- Default
      default_prompt = {
        provider = require("model.providers.openai"),
        options = { url = openai_compat_url },
        params = {
          model = 'qwen3.8-27b-q8'
        },
        transform = require("model.prompts.extract").markdown_code,
        builder = function(input)
          return {
            --prompt = 'You are a 10x super elite programmer. Continue only with code. ' .. input .. '<|end_of_turn|>'
            --prompt = 'You are a 10x super elite programmer. Here is your task: ' .. input .. ' Continue only with code.'
            prompt = input 
          }
        end,
        ft = 'mchat',
      },
      --

      -- - -
      -- OpenAI compat - is this where this argument goes?
      compat = vim.tbl_extend('force', require("model.providers.openai").default_prompt, {
        options = {
          --url = 'http://127.0.0.1:8000/v1/'
          --url = 'http://127.0.0.1:11434/v1/'
          url = openai_compat_url
        }
      }),
      --

      chats = {
        -- flash-next ik (GPU 0, np1 x 128k)
        ['qm'] = {
          provider = require("model.providers.openai"),
          params = {
            temperature = 0.2,
            max_tokens = 1000,
            model = "qwen3.8-flash-next-ik",
          },
          options = { url = openai_compat_url },
          system = "You are an expert programmer.",
          create = input_if_selection,
          run = function(messages, config)
            if config.system then
              table.insert(messages, 1, {
                role = "system",
                content = config.system,
              })
            end
            return { messages = messages }
          end,
        },
        -- 27B Q8 + MTP (GPU 0, 4 slots x 160k)
        ['ql'] = {
          provider = require("model.providers.openai"),
          params = {
            temperature = 0.2,
            max_tokens = 1000,
            model = "qwen3.8-27b-q8",
          },
          options = { url = openai_compat_url },
          system = "You are an expert programmer.",
          create = input_if_selection,
          run = function(messages, config)
            if config.system then
              table.insert(messages, 1, {
                role = "system",
                content = config.system,
              })
            end
            return { messages = messages }
          end,
        },


        -- - Qwen , instruct - --
        --['qwen14-only-code'] = {
        --  provider = require("model.providers.ollama"),
        --  params = {
        --    model = 'qwen2.5-coder:14b-instruct-q4_K_M'
        --  },
        --  --transform = require("model.prompts.extract").markdown_code,
        --  create = input_if_selection,
        --  run = require('model.format.starling').chat,
        --  builder = function(input)
        --    return {
        --      prompt = 'You are a 10x super elite programmer. Continue only with code. ' .. input .. '<|end_of_turn|>'
        --      --prompt = 'You are a 10x super elite programmer. Here is your task: ' .. input .. ' Continue only with code.'
        --      --prompt = 'You are a 10x super elite programmer. The context related to your task: ' .. input .. ' Provide an implementation valid code in markdown formatting.'
        --    }
        --  end
        --}
      },

      prompts = {
        -- - Qwen medium, instruct - --
        --qwen = {
        --  provider = require("model.providers.ollama"),
        --  params = {
        --    model = 'qwen2.5-coder:7b-instruct-q4_K_M'
        --  },
        --  ft="mchat",
        --  transform = require("model.prompts.extract").markdown_code,
        --  builder = function(input)
        --    return {
        --      --prompt = 'You are a 10x super elite programmer. Continue only with code. ' .. input .. '<|end_of_turn|>'
        --      --prompt = 'You are a 10x super elite programmer. Here is your task: ' .. input .. ' Continue only with code.'
        --      prompt = 'You are a 10x super elite programmer. Here is your task: ' .. input .. ' Provide an implementation valid code in markdown formatting.'
        --    }
        --  end
        --},
        -- - Qwen large, instruct - --
        --['qwen14-instruct'] = {
        --  provider = require("model.providers.ollama"),
        --  params = {
        --    model = 'qwen2.5-coder:14b-instruct-q4_K_M'
        --  },
        --  --ft="mchat",
        --  transform = require("model.prompts.extract").markdown_code,
        --  mode = require('model').mode.INSERT_OR_REPLACE,
        --  builder = function(input, context)
        --    --<|im_start|>system\nYou are Qwen, created by Alibaba Cloud. 
        --    --You are a helpful assistant.<|im_end|>\n<|im_start|>user\nGive me a short introduction to large language model.<|im_end|>\n<|im_start|>assistant\n
        --    local sys_str = 'You are Qwen, created by Alibaba Cloud. You are a helpful assistant.'
        --    return {
        --      --prompt = 'You are a 10x super elite programmer. Continue only with code. ' .. input .. '<|end_of_turn|>'
        --      --prompt = 'You are a 10x super elite programmer. Here is your task: ' .. input .. ' Continue only with code.'
        --      --prompt = 'You are a 10x super elite programmer. The context related to your task: ' .. context.args or 'You are a helpful assistant.' .. '\nAnd here is the input: ' .. input 
        --      prompt = '<|im_start|>system\n' .. sys_str ..'<|im_end|>\n<|im_start|>user\n' .. context.args or '' .. '\nHere is the input:\n' .. input .. '<|im_end|>\n<|im_start|>assistant\n'
        --    }
        --  end
        --},
        ['q'] = {
          provider = require("model.providers.openai"),
          params = { model = "qwen3.8-flash-next-ik" },
          options = { url = openai_compat_url },
          builder = function(input, context)
            local current_buf_lang = vim.api.nvim_get_option_value('filetype', { buf = 0 })
            return {
              messages = {
                {
                  role = 'system',
                  content = "You are an expert programmer editing a " .. current_buf_lang .. " file. Respond with only code."
                },
                {
                  role = 'user',
                  content = input
                }
              }
            }
          end,
          transform = require("model.prompts.extract").markdown_code,
        },

        -- This one sort of works
        ['qwen-lsp'] = {
          provider = require("model.providers.openai"),
          mode = require("model").mode.INSERT,
          params = {
            temperature = 0.2,
            max_tokens = 1000,
            model = "qwen3.8-flash-next-ik",
          },
          options = { url = openai_compat_url },
          builder = function(input, context)
            return require("model.providers.openai").adapt(code_replace_fewshot(input, context))
          end,
          transform = require("model.prompts.extract").markdown_code,
        },


        -- trying this one
        ['q-append'] = {
          provider = require("model.providers.openai"),
          mode = require("model").mode.APPEND,
          params = {
            temperature = 0.2,
            max_tokens = 1000,
            model = "qwen3.8-flash-next-ik",
          },
          options = { url = openai_compat_url },
          builder = function(input, context)
            return require("model.providers.openai").adapt(code_replace_fewshot(input, context))
          end,
          transform = require("model.prompts.extract").markdown_code,
        },

        ['qwen-lsp-ior'] = {
          provider = require("model.providers.openai"),
          mode = require("model").mode.INSERT_OR_REPLACE,
          params = {
            temperature = 0.2,
            max_tokens = 1000,
            model = "qwen3.8-27b-q8",
          },
          options = { url = openai_compat_url },
          builder = function(input, context)
            return require("model.providers.openai").adapt(code_replace_fewshot(input, context))
          end,
          transform = require("model.prompts.extract").markdown_code,
        },
        -- Rapper --
        ['to rap'] = {
          provider = require("model.providers.openai"),
          hl_group = 'Title',
          params = { model = "qwen2.5-coder:14b-instruct-q4_K_M" },
          options = { url = openai_compat_url },
          builder = function(input)
            return {
              messages = {
                {
                  role = 'system',
                  content = "Explain the code in 90's era rap lyrics"
                },
                {
                  role = 'user',
                  content = input
                }
              }
            }
          end,
        }
      --
      }
    }
  end,
  --    ['ollama:starling'] = {
  --	    provider = ollama,
  --	    params = {
  --	      model = 'starling-lm'
  --	    },
  --	    builder = function(input)
  --	      return {
  --		prompt = 'GPT4 Correct User: ' .. input .. '<|end_of_turn|>GPT4 Correct Assistant: '
  --	      }
  --	    end
  --	  },

  -- To override defaults add a config field and call setup()

  -- config = function()
  --   require('model').setup({
  --     prompts = {..},
  --     chats = {..},
  --     ..
  --   })
  --
  --   require('model.providers.llamacpp').setup({
  --     binary = '~/path/to/server/binary',
  --     models = '~/path/to/models/directory'
  --   })
  --end
}


