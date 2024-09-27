using EFCore.AutomaticMigrations;
using Microsoft.EntityFrameworkCore;
using myapi.Data;
using myapi.Endpoints;
using myapi.Repositories;
using myshared.Services;
using myshared.Models;
using myapi.Services;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddDbContext<MssqlDataContext>(options =>
	options.UseSqlServer(builder.Configuration.GetConnectionString("Mssql")));

// controllers
builder.Services.AddScoped<MssqlExampleModelRepository>();
//builder.Services.AddScoped<IMssqlExampleModelRepository, MssqlExampleModelRepository>();
//builder.Services.AddScoped<EnvironmentVariableService>();
//builder.Services.AddScoped<BackupService>();

builder.Services.Configure<IISOptions>(options =>
{
	options.ForwardClientCertificate = false;
});

// minimal api
//builder.Services.AddDbContext<DataContext>(opt => opt.UseInMemoryDatabase("PortfolioProjects"));

// nosql start
builder.Services.AddScoped<NosqlDataContext>();
builder.Services.Configure<NosqlDataContext>(
	builder.Configuration.GetSection("NosqlDatabase"));

builder.Services.AddScoped<NosqlExampleModelRepository>();

builder.Services.AddScoped<ExampleService>();

//builder.Services.AddSingleton<ExampleService>();

// nosql end

builder.Services.AddScoped<ExampleModelRepository>();



var app = builder.Build();

// update-database on build
using (var scope = app.Services.CreateScope())
{
	var services = scope.ServiceProvider;

	//var backupService = services.GetRequiredService<BackupService>();
	//backupService.BackupDb();

	var context = services.GetRequiredService<MssqlDataContext>();

    // using your manually created migrations, automatically runs update-database 
    context.Database.Migrate();

    // runs update-database without the need for migrations
    //MigrateDatabaseToLatestVersion.Execute(context, new DbMigrationsOptions { AutomaticMigrationDataLossAllowed = true });


    //context.Database.EnsureCreated();
    //context.Database.Migrate();

    // without having to manually create migrations, fully automatic, requires NuGet EFCode.AutomaticMigrations
    // without options 
    //MigrateDatabaseToLatestVersion.Execute(context);
    //var envVarService = services.GetRequiredService<EnvironmentVariableService>();
    //Console.WriteLine(envVarService.GetConnStr());

    // with options
    /*try
	{
		MigrateDatabaseToLatestVersion.Execute(context,
			new DbMigrationsOptions
			{
				AutomaticMigrationsEnabled = true,
				AutomaticMigrationDataLossAllowed = true
			}
		);
	}
	catch (Exception e){
		Console.WriteLine(e.ToString());
	}*/

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

// controllers - incomment this and outcomment below to use controllers v
//app.MapControllers();

// minimal api endpoints - outcomment this and incomment above to use controllers ^
app.MapExampleModelEndpoints();

/*app.MapGroup("/portfolioprojects")
	.MapPortfolioProjectsEndpoints()
	.WithTags("Public");*/

app.Run();

/*using (var scope = app.Services.CreateScope())
{
	var services = scope.ServiceProvider;
	var envVarService = services.GetRequiredService<EnvironmentVariableService>();
	Console.WriteLine(envVarService.GetConnStr());
}*/