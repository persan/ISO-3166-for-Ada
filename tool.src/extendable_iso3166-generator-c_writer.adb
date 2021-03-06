with Ada.Directories; use Ada.Directories;
procedure Extendable_ISO3166.Generator.C_Writer (Name_Map : String_Maps.Map; Target_Dir : String) is
   procedure Put_Header (F : Ada.Text_IO.File_Type) is
   begin
      Put_Line (F, "//  ===================================================================");
      Put_Line (F, "//  This file is generated from an iso-3166 description");
      Put_Line (F, "//  Do not edit by hand!");
      Put_Line (F, "//  If more entries are needed write a new  xmlfile and run the tool");
      Put_Line (F, "//  with both the basefile and the extras as arguments");
      Put_Line (F, "//  ===================================================================");
      Put_Line (F, "");
   end Put_Header;
   F      : Ada.Text_IO.File_Type;
   First  : Boolean := True;

begin
   --  Generate the mappings
   Put_Line ("Gernerating :ISO_3166.mappings and ISO_3166.database for c");

   Create (F, Ada.Text_IO.Out_File, Compose (Target_Dir, "ISO_3166_mappings.h"));
   Put_Header (F);
   Put_Line (F, "   enum ISO_3166_Country_Enum");

   for I of Name_Map loop
      Put (F, (if First then "     {" else "," & ASCII.LF & "      "));
      Put (F, Normalize (I.Name.all));
      First := False;
   end loop;
   Put_Line (F, "};");

   --  -- Generate the database
   Close (F);
   Create (F, Ada.Text_IO.Out_File, Compose (Target_Dir, "ISO_3166_database.c"));
   Put_Header (F);

   Put_Line (F, "#include <ISO_3166_database.h>");
   Put_Line (F, "#include <stdlib.h>");
   Put_Line (F, "#include <string.h>");

   for I of Name_Map loop
      Put (F, "   static struct ISO_3166_Country " & Normalize (I.Name.all) & "_data =  {""" & I.Name.all & """,");
      Put (F, """" & Normalize (I.Alpha_2.all) & """,");
      Put (F, """" & Normalize (I.Alpha_3.all) & """,");
      Put (F, """" & Normalize (I.Iso_3166_2.all) & """,");
      Put (F, I.Nationality_Code'Img & ",");
      Put (F, """" & Normalize (I.Region.all) & """,");
      Put (F, """" & Normalize (I.Sub_Region.all) & """,");
      Put (F, """" & Normalize (I.Intermediate_Region.all) & """,");
      Put (F, I.Region_Code'Img & ",");
      Put (F, I.Sub_Region_Code'Img & ",");
      Put_Line (F, I.Intermediate_Region_Code'Img & "};");
   end loop;
   --
   Put_Line (F, "static struct ISO_3166_Country* Data[] =");
   First := True;
   for I of Name_Map loop
      Put (F, (if First then "      {" else "," & ASCII.LF & "      "));
      Put (F, "&" & Normalize (I.Name.all) & "_data");
      First := False;
   end loop;

   Put_Line (F, ",");
   Put_Line (F, "      NULL};");
   Put_Line (F, "");
   Put_Line (F, "");
   Put_Line (F, "struct ISO_3166_Country *ISO_3166_get_from_string(char *name) {");
   Put_Line (F, "  struct ISO_3166_Country*  cursor = Data[0];");
   Put_Line (F, "  while (cursor) {");
   Put_Line (F, "    if (strcmp(cursor->Iso_3166_2, name) == 0 | strcmp(cursor->Name, name) == 0 |");
   Put_Line (F, "        strcmp(cursor->Alpha_2, name) == 0 | strcmp(cursor->Alpha_3, name) == 0) {");
   Put_Line (F, "      return cursor;");
   Put_Line (F, "    };");
   Put_Line (F, "    cursor ++;");
   Put_Line (F, "  };");
   Put_Line (F, "  return &Undefined_data;");
   Put_Line (F, "};");
   Put_Line (F, "struct ISO_3166_Country *ISO_3166_get_from_code(int code) {");
   Put_Line (F, "  struct ISO_3166_Country*  cursor = Data[0];");
   Put_Line (F, "  while (cursor) {");
   Put_Line (F, "    if (cursor->Country_Code == code){");
   Put_Line (F, "      return cursor;");
   Put_Line (F, "    };");
   Put_Line (F, "    cursor ++;");
   Put_Line (F, "  };");
   Put_Line (F, "  return &Undefined_data;");
   Put_Line (F, "};");

   Close (F);
end Extendable_ISO3166.Generator.C_Writer;
