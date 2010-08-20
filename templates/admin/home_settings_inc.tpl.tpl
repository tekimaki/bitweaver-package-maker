{* Are there homeable settings? *}
{{if $config.homeable}}
		{jstab title="{{$Package}} Home Settings"}
			{legend legend="{{$Package}} Home Settings"}
				<div class="row">
					{formlabel label="{{$Package}} Home Type"}
					{forminput}
						<select name="{{$package}}_home_type" id="home{{$Package}}">
							{section name=ix loop=$homeTypes}
								<option value="{$homeTypes[ix]|escape}" {if ${{$package}}_home_type == $homeTypes[ix]}selected="selected"{/if} >{$homeTypes[ix]}</option>
							{/section}
						</select>
					{/forminput}
				</div>		
{* Output for each type *}
{{foreach from=$config.types key=typeName item=type name=types}}
				<div class="row">
					{formlabel label="Home {{$typeName|capitalize}}" for="home{{$typeName|capitalize}}"}
					{forminput}
						<select name="{{$package}}_{{$typeName}}_home_id" id="home{{$typeName|capitalize}}">
							{section name=ix loop=${{$typeName}}_data}
								<option value="{${{$typeName}}_data[ix].{{$typeName}}_id|escape}" {if ${{$typeName}}_data[ix].{{$typeName}}_id eq ${{$package}}_{{$typeName}}_home_id}selected="selected"{/if}>{${{$typeName}}_data[ix].title|escape|truncate:20:"...":true}</option>
							{sectionelse}
								<option>{tr}No records found{/tr}</option>
							{/section}
						</select>
						{formhelp note="This is the {{$typeName}} that will be displayed when viewing the {{$package}} homepage if {{$Package}} Home Type above is set to {{$typeName}}"}
					{/forminput}
				</div>
{* End foreach type *}
{{/foreach}}
			{/legend}
			<div class="row submit">
				<input type="submit" name="{{$package}}_settings" value="{tr}Change preferences{/tr}" />
			</div>
		{/jstab}
{* End homeable section *}
{{/if}}

