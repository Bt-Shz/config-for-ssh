vim.opt.rtp:prepend(vim.fn.getcwd())
vim.g.mapleader = " "
require("config.keymaps")
local run = vim.fn.maparg(" cc", "n", false, true).callback
assert(type(run) == "function")

local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local function execute(file, filetype)
  vim.cmd.edit(vim.fn.fnameescape(file))
  vim.bo.filetype = filetype
  run()
  local job = vim.b.terminal_job_id
  assert(job, "Runner must open a terminal")
  local status = vim.fn.jobwait({ job }, 10000)[1]
  assert(status ~= -1, "Runner timed out")
  vim.cmd("bdelete!")
  return status
end

for _, filetype in ipairs({ "c", "cpp" }) do
  local compiler = filetype == "c" and "gcc" or "g++"
  assert(vim.fn.executable(compiler) == 1, compiler .. " required for runner checks")
  local dir = root .. "/" .. filetype
  vim.fn.mkdir(dir, "p")
  local file = dir .. "/lesson's | example." .. filetype
  vim.fn.writefile({ "input" }, dir .. "/input.txt")
  vim.fn.writefile({
    "#include <stdio.h>",
    "int main(void) {",
    '  FILE *input = fopen("input.txt", "r");',
    "  if (!input) return 2;",
    "  fclose(input);",
    '  FILE *count = fopen("run_count", "a");',
    "  if (!count) return 3;",
    '  fputs("run\\n", count);',
    "  fclose(count);",
    "  return 0;",
    "}",
  }, file)
  assert(execute(file, filetype) == 0, "Compile/run must handle quoted paths and source-directory cwd")
  assert(vim.deep_equal(vim.fn.readfile(dir .. "/run_count"), { "run" }))

  vim.fn.writefile({ "invalid source" }, file)
  assert(execute(file, filetype) ~= 0, "Failed compilation must report failure")
  assert(
    vim.deep_equal(vim.fn.readfile(dir .. "/run_count"), { "run" }),
    "Failed compile must not run stale executable"
  )
end

print("runner: passed")
