# TimeTrackingBar _(to be renamed)_
> Taskbar As A Service

## Status
Barely did anything, just set up the project. Not even really WIP

## Idea
Inspired by [https://github.com/tonsky/AnyBar](https://github.com/tonsky/AnyBar).  
This project (initially thought to be a time tracker) aims to be a stupid taskbar list provider.
On startup, it connects to a websocket server and listens for certain events (see below).
It also sends back an event as soon as an entry is clicked. 

The goal is to have a dumb taskbar that can be controlled by _any_ other software that is capable of creating a websocket server.

## Events _(wip)_

### Server -> Taskbar
- `title: <TITLE>`: sets the title of the taskbar
- `addItem: <ITEM_NAME>`: adds a list item with given name
- `removeItem: <ITEM_NAME>`: removes a list item with given name
- `clearItems`: removes all items

### Taskbar -> Server
- `clicked: <ITEM_NAME>`: informs server that an item has been clicked

## Why not xBar, Swiftbar, bitbar, ...?
I want this to be a little bit more reative and connectable, so bash scripts (e.g. as a proxy) are not the way i want to go.
Therefore, websockets.

## License
MIT

## Help
I really don't know Swift, so feel free to help me out
