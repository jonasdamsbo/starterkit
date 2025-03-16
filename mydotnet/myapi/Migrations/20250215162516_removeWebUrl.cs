using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace myapi.Migrations
{
    /// <inheritdoc />
    public partial class removeWebUrl : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "ExampleModels",
                keyColumn: "Id",
                keyValue: "673697f3ee328ebb2ba5d8d3");

            migrationBuilder.DeleteData(
                table: "ExampleNavigationProperties",
                keyColumn: "Id",
                keyValue: "673697f3ee328ebb2ba5d8d4");

            migrationBuilder.DeleteData(
                table: "ExampleNavigationProperties",
                keyColumn: "Id",
                keyValue: "673697f3ee328ebb2ba5d8d5");

            migrationBuilder.DeleteData(
                table: "ExampleNavigationProperties",
                keyColumn: "Id",
                keyValue: "673697f3ee328ebb2ba5d8d6");

            migrationBuilder.DeleteData(
                table: "ExampleModels",
                keyColumn: "Id",
                keyValue: "673697f3ee328ebb2ba5d8cf");

            migrationBuilder.DeleteData(
                table: "ExampleModels",
                keyColumn: "Id",
                keyValue: "673697f3ee328ebb2ba5d8d1");

            migrationBuilder.DropColumn(
                name: "WebUrl",
                table: "ExampleModels");

            migrationBuilder.InsertData(
                table: "ExampleModels",
                columns: new[] { "Id", "Description", "Title" },
                values: new object[,]
                {
                    { "67b0bfec0521f6c22218c93b", "Some field of first example", "First example" },
                    { "67b0bfec0521f6c22218c93d", "Some field of second example", "Second example" },
                    { "67b0bfec0521f6c22218c93f", "Some field of third example", "Third example" }
                });

            migrationBuilder.InsertData(
                table: "ExampleNavigationProperties",
                columns: new[] { "Id", "ExampleModelId", "Title" },
                values: new object[,]
                {
                    { "67b0bfec0521f6c22218c940", "67b0bfec0521f6c22218c93b", "First navprop" },
                    { "67b0bfec0521f6c22218c941", "67b0bfec0521f6c22218c93b", "Second navprop" },
                    { "67b0bfec0521f6c22218c942", "67b0bfec0521f6c22218c93d", "Third navprop" }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "ExampleModels",
                keyColumn: "Id",
                keyValue: "67b0bfec0521f6c22218c93f");

            migrationBuilder.DeleteData(
                table: "ExampleNavigationProperties",
                keyColumn: "Id",
                keyValue: "67b0bfec0521f6c22218c940");

            migrationBuilder.DeleteData(
                table: "ExampleNavigationProperties",
                keyColumn: "Id",
                keyValue: "67b0bfec0521f6c22218c941");

            migrationBuilder.DeleteData(
                table: "ExampleNavigationProperties",
                keyColumn: "Id",
                keyValue: "67b0bfec0521f6c22218c942");

            migrationBuilder.DeleteData(
                table: "ExampleModels",
                keyColumn: "Id",
                keyValue: "67b0bfec0521f6c22218c93b");

            migrationBuilder.DeleteData(
                table: "ExampleModels",
                keyColumn: "Id",
                keyValue: "67b0bfec0521f6c22218c93d");

            migrationBuilder.AddColumn<string>(
                name: "WebUrl",
                table: "ExampleModels",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.InsertData(
                table: "ExampleModels",
                columns: new[] { "Id", "Description", "Title", "WebUrl" },
                values: new object[,]
                {
                    { "673697f3ee328ebb2ba5d8cf", "Some field of first example", "First example", "google.dk" },
                    { "673697f3ee328ebb2ba5d8d1", "Some field of second example", "Second example", "google.dk" },
                    { "673697f3ee328ebb2ba5d8d3", "Some field of third example", "Third example", "google.dk" }
                });

            migrationBuilder.InsertData(
                table: "ExampleNavigationProperties",
                columns: new[] { "Id", "ExampleModelId", "Title" },
                values: new object[,]
                {
                    { "673697f3ee328ebb2ba5d8d4", "673697f3ee328ebb2ba5d8cf", "First navprop" },
                    { "673697f3ee328ebb2ba5d8d5", "673697f3ee328ebb2ba5d8cf", "Second navprop" },
                    { "673697f3ee328ebb2ba5d8d6", "673697f3ee328ebb2ba5d8d1", "Third navprop" }
                });
        }
    }
}
