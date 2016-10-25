#!/usr/bin/env julia

# check args (ARGS[1] -> csv file)
if (length(ARGS) != 1 && length(ARGS) != 2) ||
   (length(ARGS) == 1 && !isfile(ARGS[1])) ||
   (length(ARGS) == 2 && (ARGS[1] != "--replace" || !isfile(ARGS[2])))
    println("Wrong usage.")
    println("plots.jl [--replace] <plots-csv>")
    exit(1)
end

using DataFrames
using Gadfly
using YAJP

# directory where config. is located
CONFDIR = "conf"
# directory where plots should be stored
IMGDIR = "img"
# directory where traces are located
TRACEDIR = "lfs"

if ARGS[1] != "--replace"
    replace = false
    plots = readtable(ARGS[1], allowcomments=true)
else
    replace = true
    plots = readtable(ARGS[2], allowcomments=true)
end

by(plots, [:framework, :application, :run]) do subdf
    # load trace, if not found, warn and continue
    found = true
    tr = try
        trace(joinpath(TRACEDIR,
                            subdf[1,:framework],
                            subdf[1,:application],
                            subdf[1,:run],
                            "paje.csv"),
                   joinpath(CONFDIR,
                            subdf[1,:framework],
                            subdf[1,:application],
                            "YAJP.yaml"),
                   true)
    catch exception
        warn("$(subdf[1,:framework]) - $(subdf[1,:application]) - $(subdf[1,:run]): $(exception)")
        found = false
    end
    if found
        # create dir in IMGDIR, if needed
        plotsdir = joinpath(IMGDIR,
                            subdf[1,:framework],
                            subdf[1,:application],
                            subdf[1,:run])
        mkpath(plotsdir)
        # iterate over entries
        for entry in eachrow(subdf)
            # create string of time step
            ts = try
                string(convert(Int, entry[:timestep]))
            catch exception
                string(entry[:timestep])
            end
            # load heat map
            if replace || !isfile(joinpath(plotsdir,
                                           "load-"*
                                           ts*
                                           ".pdf"))
                # plot load heat map, if not needed
                try
                    # plot
                    pl = YAJP.loadplot(tr, entry[:timestep])
                    # draw
                    draw(
                        PDF(
                            joinpath(
                                plotsdir,
                                "load-"*ts*".pdf"),
                            30cm,
                            18cm),
                        vstack(pl))
                catch exception
                    warn("$(entry[:framework]) - $(entry[:application]) - $(entry[:run]) - $(entry[:timestep]): $(exception)")
                    continue
                end
            end
            # unlabeled load heat map
            if replace || !isfile(joinpath(plotsdir,
                                           "unlabeled-load-"*
                                           ts*
                                           ".pdf"))
                # plot load heat map, if not needed
                try
                    # plot
                    pl = YAJP.loadplot(tr, entry[:timestep], false)
                    # draw
                    draw(
                        PDF(
                            joinpath(
                                plotsdir,
                                "unlabeled-load-"*ts*".pdf"),
                            30cm,
                            18cm),
                        vstack(pl))
                catch exception
                    warn("$(entry[:framework]) - $(entry[:application]) - $(entry[:run]) - $(entry[:timestep]): $(exception)")
                    continue
                end
            end
            # metrics plots
            pl = try
                YAJP.metricsplot(tr,
                                 entry[:timestep],
                                 true)
            catch exception
                warn("$(entry[:framework]) - $(entry[:application]) - $(entry[:run]) - $(entry[:timestep]): $(exception)")
                continue
            end
            # severity metrics plot
            if replace || !isfile(joinpath(plotsdir,
                                           "severity-"*
                                           ts*
                                           ".pdf"))
                # draw severity
                draw(
                    PDF(
                        joinpath(
                            plotsdir,
                            "severity-"*ts*".pdf"),
                        30cm,
                        4*8cm),
                    vstack(pl[1:4]))
            end
            # shape metrics plot
            if replace || !isfile(joinpath(plotsdir,
                                           "shape-"*
                                           ts*
                                           ".pdf"))
                # draw shape
                draw(
                    PDF(
                        joinpath(
                            plotsdir,
                            "shape-"*ts*".pdf"),
                        30cm,
                        2*8cm),
                    vstack(pl[5:6]))
            end
        end
    end
end
