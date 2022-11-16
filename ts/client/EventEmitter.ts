type EventID = string | symbol | symbol;
type EventCallback = (...args: unknown[]) => unknown;

interface EventStrap {
	once: boolean;
	func: EventCallback;
}

class EventEmitter<T extends EventID> {
	public _events: Record<T | EventID, EventStrap[]>;

	[key: string]: unknown;
	constructor(obj?: Record<string, unknown>) {
		const o = obj || {};
		for (const [i, v] of pairs<Record<string, unknown>>(o)) {
			this[i] = v;
		}

		this._events = {} as Record<T | EventID, EventStrap[]>;
	}

	on(evt: T | EventID, func: EventCallback): void {
		if (!this._events[evt]) this._events[evt] = [];
		this._events[evt].push({
			once: false,
			func,
		});
	}

	once(evt: T | EventID, func: EventCallback): void {
		if (!this._events[evt]) this._events[evt] = [];
		this._events[evt].push({
			once: true,
			func,
		});
	}

	off(evt: T | EventID, func: EventCallback): void {
		if (!this._events[evt]) return;
		for (const v of this._events[evt]) {
			if (v.func === func) {
				this._events[evt].remove(this._events[evt].indexOf(v));
			}
		}
	}

	emit(evt: T | EventID, ...args: unknown[]): void {
		if (!this._events[evt]) return;
		for (const v of this._events[evt]) {
			v.func(...args);
			if (v.once) this.off(evt, v.func);
		}
	}
}

export { EventEmitter };
