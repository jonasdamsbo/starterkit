using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myapi.Endpoints;
using myapi.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<DataContext>(options =>
	options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// controllers
builder.Services.AddScoped<IPortfolioService, PortfolioService>();

// minimal api
//builder.Services.AddDbContext<DataContext>(opt => opt.UseInMemoryDatabase("PortfolioProjects"));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
	app.UseSwagger();
	app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

// controllers
app.MapControllers();

// minimap api endpoints
/*app.MapPortfolioProjectsEndpoints();
app.MapGroup("/portfolioprojects")
	.MapPortfolioProjectsEndpoints()
	.WithTags("Public");*/

app.Run();
