page 50139 APIStudentPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = StudentAPI;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;

                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;

                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;

                }
                field("Web-ID"; Rec."Web-ID")
                {
                    ApplicationArea = All;

                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(GetDataFromRestAPI)
            {
                ApplicationArea = All;



                trigger OnAction();
                var
                    http_client: HttpClient;
                    http_responseMsg: HttpResponseMessage;
                    response: Text;
                begin
                    if http_client.Get('https://jsonplaceholder.typicode.com/users', http_responseMsg) then begin
                        http_responseMsg.Content.ReadAs(response);

                        Message(response);
                        Message('hello hi');

                        ReadFromResponse(response);

                    end;


                end;
            }
        }
    }

    procedure ReadFromResponse(response: Text)
    var
        i: Integer;
        json_array: JsonArray;
        json_value: JsonValue;
        json_object: JsonObject;
        json_token, ValueJToken : JsonToken;
        recStudent: Record StudentAPI;
        studID: Integer;
    begin

        recStudent.Reset();
        if recStudent.FindLast() then
            studID := recStudent.ID + 1
        else
            studID := 1;


        if json_token.ReadFrom(response) then begin
            if json_token.IsArray then begin
                json_array := json_token.AsArray();

                for i := 0 to json_array.Count - 1 do begin

                    json_array.Get(i, json_token);

                    if json_token.IsObject then begin
                        json_object := json_token.AsObject();

                        recStudent.Init();
                        recStudent.ID := studID;

                        if json_object.Get('name', ValueJToken) then begin
                            recStudent.Name := ValueJToken.AsValue().AsText();

                        end;

                        if json_object.Get('email', ValueJToken) then begin
                            recStudent.Email := ValueJToken.AsValue().AsText();
                        end;

                        if json_object.Get('id',ValueJToken) then begin
                            recStudent."Web-ID" := ValueJToken.AsValue().AsInteger()
                        end;
                        
                        recStudent.Modify();


                        // recStudent.Insert();
                        studID := studID + 1;

                    end;




                end;



            end;
        end;

    end;

}