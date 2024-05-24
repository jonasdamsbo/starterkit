using EFCore.AutomaticMigrations;
using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myapi.Endpoints;
using myapi.Services;
using myshared.Services;

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
//builder.Services.AddScoped<EnvironmentVariableService>();

builder.Services.Configure<IISOptions>(options =>
{
	options.ForwardClientCertificate = false;
});

// minimal api
//builder.Services.AddDbContext<DataContext>(opt => opt.UseInMemoryDatabase("PortfolioProjects"));

var app = builder.Build();

// update-database on build
using (var scope = app.Services.CreateScope())
{
	var services = scope.ServiceProvider;

	var context = services.GetRequiredService<DataContext>();

	// using your manually created migrations, automatically runs update-database
	//context.Database.Migrate();

	// without having to manually create migrations, fully automatic, requires NuGet EFCode.AutomaticMigrations
	// without options 
	//MigrateDatabaseToLatestVersion.Execute(context);
	//var envVarService = services.GetRequiredService<EnvironmentVariableService>();
	//Console.WriteLine(envVarService.GetConnStr());

	// with options 
	MigrateDatabaseToLatestVersion.Execute(context,
		new DbMigrationsOptions { 
			AutomaticMigrationsEnabled = true,
			AutomaticMigrationDataLossAllowed = true
		}
	);

	//Console.WriteLine(envVarService.GetConnStr()); 
}

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

// minimal api endpoints
/*app.MapPortfolioProjectsEndpoints();
app.MapGroup("/portfolioprojects")
	.MapPortfolioProjectsEndpoints()
	.WithTags("Public");*/

app.Run();

/*using (var scope = app.Services.CreateScope())
{
	var services = scope.ServiceProvider;
	var envVarService = services.GetRequiredService<EnvironmentVariableService>();
	Console.WriteLine(envVarService.GetConnStr());
}*/