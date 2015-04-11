---
title: "PyCon Day 3: Migraines Are Fun"
feature-img: "images/pycon-header.PNG"
---

Started my day with a massive ongoing migraine that had me hiding in my hotel room with a towel over my eyes, praying for either death or my migraine meds to start working.

## Pythons are Deaf and so are some Pythonistas

*Will write up my notes on this amazing session later once I can digest it. As a parent of deaf kids and someone interested in culturally appropriate user interfaces this session has been the conf highlight so far.*

## Debugging "Hard" Technical Problems, Alex Gaynor

What is debugging?

When does this bug occcur? (Figure out "Sometimes my server crashes" vs. "When this happen my server crashes")

How does it crash? In a particular situation, or in a particular function?

What is a "Hard" problem? It's something that takes more than 10-15 minutes to debug/figure out. Like, *really* unexpected. When a normal adhoc debugging process fails, now you're in "hard" territory.

Timing and ordering bugs: thread, greenlet, asyncio, etc. It's hard to track what's happening in different streams in your program. Also ordering bugs that make it hard to reason about the order of things happeniig.

Bugs that cross library or system boundaries. API docs and interface changes, issues.

**The worst:** *many indepent "safe" failures that conspire to make a super bug.*

### Principles of Debugging a Hard Problem

#### Everything is in scope.

*Normally* you can assume that the OS, stdlib, etc are not at fault. But a tiny bug in a system could conspire with a small bug in your code to really fail.

#### Read the source. Read *all the source*

Read your own source, read the source for libraries you are using.

#### Trust Nothing

Don't trust `repr()` - Django querysets look identical to lists in `repr()`.

Beware the monkeypatch. *weeps*

Get a lab notebook and document debugging steps. Use vcs branches as a lab notebook, using a branch for each test investigation.

### Tools

- debugger for your language (pdb)
- OS tracing (dtrace) - tells your what *syscalls* your code makes (can be hidden in your code)
- Editor or IDE you can easily *read* code in
- grep
- Domain-specific visibility tools (`lsof` for open files, `netstat` for open network sockets, etc)

Also, application-specific tools. App metrics, logging, etc.

### Techniques

**Pair Debugging:** Talk about what your trying to debug, show the process, talk about what you see in the output. Compare perceptions or assumptions about what is happening.

**Minimization:** Find a smaller program that fails in the similar way as a larger problem. if your program uses consurrency or randomness, try removing those aspects to simplify. Reduce the number of interactions you have so to reduce the complexity quadrilaterally.

**Proximate Cause:** Did you just cut a release? Did you just make a change? Use a tool like `git bisect` to find the change that introduced the bug.

**Keep your eyes on the prize:** If you find a random broken thing, don't fix that right away, document it and come back to it.

**Get out of production ASAP:** If the bug is in production, find a way to reproduce it outside of production right away.

### Story Time!

*Alex tells a story of a bug that took 3 people more than a day to debug, about 15 hours of debugging.*
