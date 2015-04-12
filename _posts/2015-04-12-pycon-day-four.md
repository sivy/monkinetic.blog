---
title: "PyCon Day 4: Lightning in a Bottle"
feature-img: "images/pycon-header.PNG"
---

Lightning talks, keynote by a PSF head, and a keynote by Jacob Kaplan-Moss. Jacob's keynote was excellent, focusing on the myth that programmers are either great or awful, and how that myth harms the industry by excluding anyone who doesn't fall into the stereotypical "programmer" temperment, skill-base, or even gender/race profile (we are not all Zuckerbergs).

I didn't really try and take notes, deciding instead to just listen and absorb. One point really stood out though: We will know we have succeeded when marginalized groups (women, persons of color, etc) are represented in our community not because they are exceptional developers, but because they are, *just like all of us*, appropriately adequate to the roles they fill.

Also, I'm re-reading [@shanley](http://twitter.com/shaneley)'s essay on the "10x Engineer". I'd recommend [getting her collection of essays on startups](http://model-view-culture.myshopify.com/products/your-startup-is-broken) and reading it; there's a lot of research and analysis there that Jacob reiterates in his talk.

*My name is Steve, and I'm a mediocre programmer.*

## Beyond Grep: Practical Logging and Metrics, Hynek Schlawack

Agenda:

- Errors
- Metrics - what's going on?! Without SSHing
- Logging and centralizing it

### Error capturing:

- fast notifications
- one notification
- useful context

Sentry (*can* you deploy it internally? Hynek says you can but I am not sure...). You get useful notifications with context, stack trace, and a "view on sentry" button, take you to see graph, number of occurences, etc. Get lots of metadata.

*Facepalm: it's right here <https://github.com/getsentry/sentry>*

Pushing data in: raven-python.

### Metrics

Numbers you save in a database! Numbers over time actually mean something. It helps you know, vs guessing.

Difference between server metrics (things you observe on a server), and application metrics (things you measure in your app).

- counters (how many times things happen)
- timers (how long things take)
- guages (number of active things)

Aggregation for trends, etc.

Correlations:

- freq/sec vs. latency, for example.

Math:

- No. reqs/second
- worst 0.01% request time
- don't try this alone! - use tools by those who know how to do this.

Monitoring:

You can apply monitors to your metrics - notify on latencies, error rates, or other anomalies - "tell me if something starts getting our of hand?"

Metrics really belong in a time series database. How long you store them and at what frequency can make a difference.

Three options:

- Librato Metrics (SaaS)
- Graphite/Statsd
- Grafana - pretty Dashboard that pulls from graphite or influx.
- InfluxDB - Graphite++ written in Go

Options for getting data into your timeseries DB:

1. External aggregation: StatsD, Reimann
    + no state, simple
    - no direct introspection

2. Aggregate in-app, deliver to DB
    + in-app dashboard, useful in db
    - have state in app, which is bad

For second option in-app, option is **greplin/scales**; collect data in the app and scales gives you a dashboard (using flask or the like)

### Logging

[Splunk](http://www.splunk.com/): *$$$ Enterprise $$$*

[Papertrail](https://papertrailapp.com/), [Loggly](https://www.loggly.com/): SaaS, seinding data to thrid party not fun

[ELK](https://www.elastic.co/webinars/elk-stack-devops-environment/): Elastic Search, Logstash, Kibana

Data - the goal:

    @timestamp {
        json: data
        that: is
        readable: info
    }

### Structlog

Structlog is not a logging system, instead it wraps your logger, and adds context and other stuff.

<https://structlog.readthedocs.org/en/stable/>

Log to standard out, and let other features (log rotation, etc) be handled by the subsystems

Log Capture:

- files
- syslog
- pipe into a logging queue

### Wait a minute...!

How do we put these three components together?

Errors:

- Capture errors in the logging integration
- Capture error info in a custom error view

Metrics:

- try to keep the metrics observable from outside (ie, metrics captured from the webserver)
- middleware (capture metrics around the request, not in it)
- extract metrics from logs (send from logstrash to graphite, for example)

Leverage monitoring:

- measure data and save it out (nagios can capture metrics from checkers)

### Remaining:

1. measure code paths
2. expose guages (how many of x right now)

<https://hynek.me/talks/beyond-grep/>

## Serialization formats are not Toys

*yaml.load is terrifying*. 

More notes later 'cause I'm playing with [structlog](https://structlog.readthedocs.org/en/stable/).