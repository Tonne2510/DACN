using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace AspnetApi.Migrations
{
    /// <inheritdoc />
    public partial class v13 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_RequestApproves_CommentId",
                table: "RequestApproves");

            migrationBuilder.AddColumn<DateTime>(
                name: "CreatedAt",
                table: "AspNetUsers",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.CreateIndex(
                name: "IX_RequestApproves_CommentId",
                table: "RequestApproves",
                column: "CommentId",
                unique: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_RequestApproves_CommentId",
                table: "RequestApproves");

            migrationBuilder.DropColumn(
                name: "CreatedAt",
                table: "AspNetUsers");

            migrationBuilder.CreateIndex(
                name: "IX_RequestApproves_CommentId",
                table: "RequestApproves",
                column: "CommentId");
        }
    }
}
