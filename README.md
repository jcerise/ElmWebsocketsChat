## Synopsis

A simple example chat app using a Python Tornado websockets server, and Elm

## Usage

To use, from the `/src` dir:

```bash
cd elm-chat
elm make Main.elm
cd ..
```
Then start the elm reactor:
```bash
elm reactor
```
Finally, start the tornado server:
```bash
python ws-server.py
```
