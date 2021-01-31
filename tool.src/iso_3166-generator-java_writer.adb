procedure ISO_3166.Generator.Java_Writer (Name_Map : STring_Maps.Map) is
   procedure Put_Header (F : Ada.Text_IO.File_Type) is
   begin
      Put_Line (F, "//  ===================================================================");
      Put_Line (F, "//  This file is generated from an iso-3166 descrition");
      Put_Line (F, "//  Do not edit by hand !");
      Put_Line (F, "//  If more entries are needed write a new  xmlfile and run the tool");
      Put_Line (F, "//  with both the basefile and the extras as arguments");
      Put_Line (F, "//  ===================================================================");
      Put_Line (F, "");
   end Put_Header;
   F      : Ada.Text_IO.File_Type;
   First  : Boolean := True;

   Max_Country_Code : Country_Code_Type := 0;


begin
   -- Generate the mappings
   Put_Line ("Gernerating :ISO_3166.mappings and ISO_3166.database");

   Create (F, Ada.Text_IO.Out_File, "src/Java/iso3166/ConuntryNames.java");
   Put_Header (F);
   Put_Line (F, "import java.util.EnumSet;");
   Put_Line (F, "import java.util.HashMap;");
   Put_Line (F, "import java.util.Map;");
   Put_Line (F, "package iso3166;");

   Put_Line (F, "    public enum ConuntryNames {");
   for I of Name_Map loop
      Put (F, (if First then "      " else "," & ASCII.LF & "      "));
      Put (F, "     " & Normalize (I.Name.all) & "(" & I.Country_Code'Img & ")");
      First := False;
   end loop;
   Put_Line (F, "    private static final Map<Integer,ConuntryNames> lookup  = new HashMap<Integer,ConuntryNames>();");
   Put_Line (F, "    static { for(ConuntryNames s : EnumSet.allOf(ConuntryNames.class)) lookup.put(s.getCode(), s);}");
   Put_Line (F, "    private int code;");
   Put_Line (F, "    private ConuntryNames(int code) { this.code = code;}");
   Put_Line (F, "    public int getCode() { return code; ");
   Put_Line (F, "    public static ConuntryNames get(int code) { return lookup.get(code);}");
   Put_Line (F, "};");

   Close (F);

   Create (F, Ada.Text_IO.Out_File, "src/Java/iso3166/Mappings.java");
   Put_Header (F);
   Put_Line (F, "package iso3166;");
   Put_Line (F, "Public class Mappings {");
   --  Put_Line (F, "     public int[ConuntryNames] ConuntryName2ConuntryCode =");
   --  First := True;
   --  for I of Name_Map loop
   --     Put (F, (if First then "     {" else "," & ASCII.LF & "      "));
   --     Put (F, Image (I.Country_Code));
   --     First := False;
   --  end loop;
   --  Put_Line (F, "   };");
   Put_Line (F, "};");
   Close (F);

   --  --  ----------------------------------------------------------------------
   --  --  Enum_2_Code
   --  --  ----------------------------------------------------------------------
   --  Put_Line (F, "   Enum_2_Code : constant array (Country_Enum)  of Country_Code_Type :=");
   --  First := True;
   --  for I of Name_Map loop
   --     Put (F, (if First then "                                   (" else "," & ASCII.LF & "                                    "));
   --     Put (F, Normalize (I.Name.all) & " => " & I.Country_Code'Img);
   --     Max_Country_Code := Country_Code_Type'Max (Max_Country_Code, I.Country_Code);
   --     First := False;
   --  end loop;
   --  Put_Line (F, ");");
   --
   --  --  ----------------------------------------------------------------------
   --  --  Code_2_Enum
   --  --  ----------------------------------------------------------------------
   --  Put_Line (F, "   Code_2_Enum : constant array (0 .." & Max_Country_Code'Img & ")  of Country_Enum :=");
   --  First := True;
   --  for I of Name_Map loop
   --     Put (F, (if First then "                   (" else "," & ASCII.LF & "                    "));
   --     Put (F,  Image (I.Country_Code) & " => " & Normalize (I.Name.all));
   --     First := False;
   --  end loop;
   --  Put_Line (F, ",");
   --  Put_Line (F, "        others => UNKONWN);");
   --

   -- Generate the database
   Create (F, Ada.Text_IO.Out_File, "src/Java/iso3166/database.java");
   Put_Header (F);
   Put_Line (F, "package iso3166");
   Put_Line (F, "class database {");
   --  for I of Name_Map loop
   --     Put_Line (F, "   " & Normalize (I.Name.all) & "_Name : aliased constant String := """ & I.Name.all & """;");
   --     Put_Line (F, "   " & Normalize (I.Name.all) & "_Alpha_2 : aliased constant String := """ & I.Alpha_2.all & """;");
   --     Put_Line (F, "   " & Normalize (I.Name.all) & "_Alpha_3 : aliased constant String := """ & I.Alpha_3.all & """;");
   --     Put_Line (F, "   " & Normalize (I.Name.all) & "_Iso_3166_2 : aliased constant String := """ & I.Iso_3166_2.all & """;");
   --     Put_Line (F, "   " & Normalize (I.Name.all) & "_Region : aliased constant String := """ & I.Region.all & """;");
   --     Put_Line (F, "   " & Normalize (I.Name.all) & "_Sub_Region : aliased constant String := """ & I.Sub_Region.all & """;");
   --     Put_Line (F, "   " & Normalize (I.Name.all) & "_Intermediate_Region : aliased constant String := """ & I.Intermediate_Region.all & """;");
   --     Put_Line (F, "   " & Normalize (I.Name.all) & "_Entry : aliased constant Country :=");
   --     Put_Line (F, "      (Name => " & Normalize (I.Name.all) & "_Name'Access,");
   --     Put_Line (F, "       Alpha_2 => " & Normalize (I.Name.all) & "_" & "Alpha_2'Access,");
   --     Put_Line (F, "       Alpha_3 => " & Normalize (I.Name.all) & "_" & "Alpha_3'Access,");
   --     Put_Line (F, "       Iso_3166_2 => " & Normalize (I.Name.all) & "_" & "Iso_3166_2'Access,");
   --     Put_Line (F, "       Country_Code => " & I.Country_Code'Img & ",");
   --     Put_Line (F, "       Region => " & Normalize (I.Name.all) & "_" & "Region'Access,");
   --     Put_Line (F, "       Sub_Region => " & Normalize (I.Name.all) & "_" & "Sub_Region'Access,");
   --     Put_Line (F, "       Intermediate_Region => " & Normalize (I.Name.all) & "_" & "Intermediate_Region'Access,");
   --     Put_Line (F, "       Region_Code => " & I.Region_Code'Img & ",");
   --     Put_Line (F, "       Sub_Region_Code => " & I.Sub_Region_Code'Img & ",");
   --     Put_Line (F, "       Intermediate_Region_Code => " & I.Intermediate_Region_Code'Img & ");");
   --
   --  end loop;
   --
   --  Put_Line (F, "   Data : constant array (Mappings.Country_Enum) of Country_Access :=");
   --  First := True;
   --  for I of Name_Map loop
   --     Put (F, (if First then "     (" else "," & ASCII.LF & "      "));
   --     Put (F, "Mappings." & Normalize (I.Name.all) & " => " & Normalize (I.Name.all) & "_Entry'Access");
   --     First := False;
   --  end loop;

   Put_Line (F, "};");
   Close (F);
end ISO_3166.Generator.Java_Writer;
