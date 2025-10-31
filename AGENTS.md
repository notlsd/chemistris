# Repository Guidelines

## Agent Principles
- If you have any questions, please ask me first - do NOT make any assumptions | 有任何问题请先问我 - 不要瞎猜
- The habit of pausing to think - Analyze the existing structure before taking action | 暂停思考的习惯 - 在行动前先分析现有结构
- A commitment to quality - It's better to do it right than to do it fast | 质量优先的价值观 - 宁可慢一点也要做对
- Holistic design thinking - Consider maintainability and consistency | 整体设计思维 - 考虑可维护性和一致性
- Use style of Code Complete 2 - provide educational style comments when necessary | 使用 Code Complete 2 的代码风格 - 必要时提供代码风格教学注释

## Project Structure & Module Organization
- Game project: `chemistris-gms/chemistris.yyp` (GMS2 2022.0.2.51).
- `scripts/` holds libraries `LIB_ALGO_*`, `LIB_DATA_*`, `LIB_DRAW_*`; keep new code with its domain.
- `objects/` defines gameplay instances (`obj_mole`, `obj_cond`, `obj_level`); `rooms/` wires menus and stages.
- `datafiles/` stores hashed CSV datasets keyed by poetry codes.
- Art and audio live in `sprites/`, `sounds/`, `tilesets/`; avoid committing generated exports.

## Build, Test, and Development Commands
- `open -a "GameMaker Studio 2" chemistris-gms/chemistris.yyp` launches the project on macOS; Windows users double-click.
- IDE `Game ▸ Create Executable ▸ Windows` builds `chemistris.exe` plus `data.win`.
- `wine chemistris-gms/chemistris.exe` checks the Windows build on macOS/Linux.
- Rebuild whenever `datafiles/` or CSV assets change to refresh the bundle.

## Coding Style & Naming Conventions
- Four-space indent; `camelCase` locals, `PascalCase` functions, `SCREAMING_SNAKE_CASE` macros.
- Resource prefixes (`obj_`, `spr_`, `lib_`, `scr_`) retain discoverability; align new libraries with existing `LIB_*`.
- Run GameMaker “Code Cleanup”; keep comments bilingual-ready and ASCII unless translating source text.

## Testing Guidelines
- Run `Check_consistency()` after editing reaction CSVs to catch stoichiometry drift.
- Play `rom_level` and `rom_menu` via the IDE; confirm reactions trigger and visuals hold.
- Record screenshots or GIFs for visible changes and attach to PRs.

## Commit & Pull Request Guidelines
- Commit summaries use imperative sentence case under 72 chars (e.g., `Add reaction balancing guard`).
- Reference issues in the body and explain CSV or asset diffs.
- PRs include gameplay impact, test notes, and media for UI updates; request review before merge.

## Data Handling Tips
- Update `LEVEL`, `REACTANT`, and `PRODUCT` CSV rows together using the same poetry code.
- Ensure new resources are registered in the IDE so they compile; remove obsolete exports.
