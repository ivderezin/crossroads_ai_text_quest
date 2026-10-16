<p align="center">
  <img src="assets/icon/app_icon.png" width="120" alt="Crossroads icon">
</p>

# Crossroads — AI Text Quest

[English version below](#-english)

Почитывая статью о засилии ИИ-авторов на литресе и ничуть этому не удивляясь, ведь я помню спрос на авторов вроде Донцовой, а также книжек Лит-РПГ, появилась идея: почему бы юзверю самому себе не генерить истории? А к тому же мелкие модельки уже довольно неплохо с этим могут справиться, причем на почти любом языке.

Вкратце суть приложения: описываешь мир и героя,
а дальше каждая сцена складывается из твоих решений: выбираешь один из
вариантов или пишешь своё действие. История длится до 12 сцен.

## Возможности

- Рассказчик на выбор: **Claude**, **GPT** или **локальная модель**,
  скачанная с Hugging Face
- История пишется на языке промпта.
- Прогресс сохраняется после каждого хода, к квесту можно вернуться позже.
- Интерфейс на русском и английском, светлая и тёмная тема по системе.

## Стек

Flutter · BLoC · freezed · json_serializable · get_it + injectable · go_router ·
dio + retrofit · flutter_edge_ai (MediaPipe) · flutter_secure_storage


## Запуск

Нужен Flutter из `.fvmrc` (используется [FVM](https://fvm.app)).

```sh
scripts/codegen.sh   # зависимости, локализация и генерация кода
fvm flutter run
```

После запуска открой настройки и добавь API-ключ Claude или GPT либо скачай
одну из локальных моделей.

## Сборка

```sh
scripts/build_android.sh   # APK в dist/
scripts/build_ios.sh       # IPA в dist/
```

---

## 🇬🇧 English

While reading an article about AI authors flooding LitRes — and not being surprised at all, given how popular authors like Dontsova and LitRPG books have always been — I had an idea: why not let users generate stories for themselves? Besides, small models can already handle this pretty well, in almost any language.

In short: you describe the world and the hero, and every scene then unfolds
from your decisions — pick one of the options or write your own action.
A story lasts up to 12 scenes.

### Features

- Choose your narrator: **Claude**, **GPT**, or a **local model**
  downloaded from Hugging Face
- The story is written in the language of your prompt.
- Progress is saved after every turn, so you can come back to a quest later.
- Russian and English UI, light and dark themes following the system setting.

### Stack

Flutter · BLoC · freezed · json_serializable · get_it + injectable · go_router ·
dio + retrofit · flutter_edge_ai (MediaPipe) · flutter_secure_storage

### Running

Requires the Flutter version from `.fvmrc` ([FVM](https://fvm.app) is used).

```sh
scripts/codegen.sh   # dependencies, localization and code generation
fvm flutter run
```

After launching, open Settings and add a Claude or GPT API key, or download
one of the local models.

### Building

```sh
scripts/build_android.sh   # APK to dist/
scripts/build_ios.sh       # IPA to dist/
```
