const fft = require('fft-js').fftInPlace;
const stdin = process.stdin;

// generate 2khz sample with sine function within random seed
function generate(f, s, r) {

	// frequency adjusted when f is null
	const ff = f || 2048;

	// frequency scale (keep it between -400 and 400)
	const rr = r || 400;

	const d = [];

	for (let i = 0; i < ff; i++)  {
		d.push(Math.sin(Math.random()) * rr);
	}

	return d;
}

// main function
function run() {

	// users can call this script with loop args to never stop
	// independent of iteration counting
	const args = process.argv.slice(2);
	const t = args.length > 0 && args[0] == 'loop'

	// number of iterations
	const it = 10

	// store execution number
	let en = 0;

	// store total execution time
	let tt = 0;

	// this was created before hand due to nodejs terrible perf when acessing 
	// global fields then to compare closely to lua (lua is good at global 'local' access)
	// we must pre-generate all frequencies before calculating fft
	// you must be aware that this won't affect overall memory measurement 
	// since lua also pre-generate its frequencies
	const generated = generate();

	// reset tt and en so we can reuse it on nextl loop
	en = 0;
	tt = 0;

	for (; en <= it && !t; en++) {

		// returns the current high-resolution real time to be used as time zero (t0)
		const t0 = process.hrtime();

		// calculate fft for data line (d')
		fft(generated);

		// calculate elapsed time starting at t0
		const t1 = process.hrtime(t0);

		// t1 converted to milli
		const mst1 = (t1[0] * 1000) + (t1[1] / 1000000);

		// accumulate last execution elapsed time
		tt += mst1;

		console.log('algorithm runner -> execution n %d total execution time %dms %ds', en, tt, tt / 1000);
	}

	console.log("process memory usage " + JSON.stringify(process.memoryUsage()));
}

// start our program
run();

process.exit();