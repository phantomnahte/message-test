import { EventEmitter } from "./EventEmitter";

const thing = {
	stuff: "banana",
};

const evt = new EventEmitter(thing);

evt.once("hi", (msg) => {
	print(msg);
});

evt.on("log", (msg) => {
	print(msg);
});

evt.emit("hi", "hello, events");
evt.emit("hi", "hello, events");

evt.emit("log", evt.stuff);
