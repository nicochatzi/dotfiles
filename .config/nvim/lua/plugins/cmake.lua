return {
  'Civitasv/cmake-tools.nvim',
  cmd = { 'CMakeOpen', 'CMakeGenerate', 'CMakeSelectCwd' },
  -- ft = 'cpp',
  opts = {
    cmake_command = 'cmake',
    cmake_build_directory = 'build',
    cmake_build_directory_prefix = '', -- when cmake_build_directory is '', this option will be activated
    cmake_generate_options = { '-B', 'build', '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },
    cmake_regenerate_on_save = true, -- Saves CMakeLists.txt file only if mofified.
    cmake_soft_link_compile_commands = true, -- if softlink compile commands json file
    cmake_compile_commands_from_lsp = false, -- automatically set compile commands location using lsp },
    cmake_build_options = {},
    cmake_console_size = 20, -- cmake output window height
    cmake_console_position = 'belowright', -- 'belowright', 'aboveleft', ...
    cmake_show_console = 'always', -- 'always', 'only_on_error'
    cmake_kits_path = nil, -- global cmake kits path
    cmake_dap_configuration = { name = 'cpp', type = 'codelldb', request = 'launch' }, -- dap configuration, optional
    cmake_variants_message = {
      short = { show = true },
      long = { show = true, max_length = 40 },
    },
  },
}
