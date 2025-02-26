using GLMakie, StatsBase, GLFW

function monte_carlo_stock(num_paths=252, time_period=1.0, steps=252, start_price=100, mu=0.05, sigma=0.2)
    dt = time_period / steps
    time = 0:dt:time_period
    paths = Matrix{Float64}(undef, length(time), num_paths)

    for i in 1:num_paths
        noise = randn(length(time) - 1)  # Random noise
        returns = (mu - 0.5 * sigma^2) * dt .+ sigma * sqrt(dt) .* noise
        paths[:, i] = vcat(start_price, start_price * exp.(cumsum(returns)))  
    end

    return time, paths
end

mu = Observable(0.05)
sigma = Observable(0.2)
time_period = 1.0
steps = 252
num_paths = Observable(252)
time, stock_paths = monte_carlo_stock(252, time_period, steps, 100, mu[], sigma[])
final_prices = stock_paths[end, :]

fig = Figure(size=(1000, 600))
grid = fig[1, 1] = GridLayout()

ax1 = Axis(grid[1, 1], xlabel="Time", ylabel="Stock Price", title="Monte Carlo Simulation")
ax2 = Axis(grid[1, 2], xlabel="Final Stock Price", ylabel="Frequency", title="Final Price Distribution")

for i in 1:252
    lines!(ax1, time, stock_paths[:, i], color=(0, 0, 1, 0.1))
end
expected_path = lines!(ax1, time, vec(mean(stock_paths, dims=2)), color=:red, linewidth=2, label="Expected Path")

hist_plot = hist!(ax2, final_prices, bins=30, color=(:green, 0.5))

drift_slider = Slider(grid[2, 1], range=0.01:0.01:0.1, startvalue=0.05)
Label(grid[3, 1], "Drift (mu)", tellwidth=false) 
vol_slider = Slider(grid[2, 2], range=0.05:0.05:0.5, startvalue=0.2)
Label(grid[3, 2], "Volatility (sigma)", tellwidth=false)

function update_simulation()
    time, new_paths = monte_carlo_stock(num_paths[], time_period, steps, 100, mu[], sigma[])
    final_prices .= new_paths[end, :]

    empty!(ax1)
    for i in 1:num_paths[]
        lines!(ax1, time, new_paths[:, i], color=(0, 0, 1, 0.1))
    end

    lines!(ax1, time, vec(mean(new_paths, dims=2)), color=:red, linewidth=2, label="Expected Path")
    hist_plot[1] = final_prices
end

on(drift_slider.value) do v
    mu[] = v
    update_simulation() 
end

on(vol_slider.value) do v
    sigma[] = v
    update_simulation() 
end

save("monte_carlo_simulation.png", fig)

display(fig)
GLFW.PollEvents()
sleep(10)