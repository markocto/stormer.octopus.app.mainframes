using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Linq.Expressions;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Transactions;
using System.Xml;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Net.Http;
using System.Net.Http.Json;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Text.Json.Serialization;
using System.Threading.Tasks;


/*using*/ var client = new HttpClient(
	new HttpClientHandler ()
	{
		ServerCertificateCustomValidationCallback = (_,_,_,_) => true
	}
);
client.BaseAddress = new Uri(OctopusParameters["RestUrl"]);
var base64Header = Convert.ToBase64String(Encoding.UTF8.GetBytes($"{OctopusParameters["LoginUser"]}:{OctopusParameters["LoginPassword"]}"));
client.DefaultRequestHeaders.Authorization = new System.Net.Http.Headers.AuthenticationHeaderValue("Basic", base64Header);
client.DefaultRequestHeaders.Add("X-CSRF-ZOSMF-HEADER", "");


async Task<Job> SubmitJob()
{
    var jcl = OctopusParameters["JCL"];
  
	var submitResult = await client.PutAsync("/zosmf/restjobs/jobs", new StringContent(jcl, null, "text/plain"));
	submitResult.EnsureSuccessStatusCode();
	var job = await submitResult.Content.ReadFromJsonAsync<Job>();

	WriteHighlight($"Submitted Job {job.JobId}");
	WriteVerbose(JsonSerializer.Serialize(job, new JsonSerializerOptions { WriteIndented = true }));
	return job;
}

async Task<Job> WaitForCompletion(Job job)
{
	while (job.RetCode == null)
	{
		WriteWait($"Waiting for completion: {job.PhaseName}");
		job = await client.GetFromJsonAsync<Job>(job.Url);
	}
	WriteHighlight($"Job completed with return code {job.RetCode}");
	return job;
}

async Task WriteOutFiles(Job job)
{
	var files = await client.GetFromJsonAsync<JobFile[]>(job.FilesUrl);
	Console.WriteLine($"{files.Length} files output");
	foreach (var file in files)
	{
		WriteHighlight($"{file.StepName} {file.DDName}: {file.RecordCount} records");

		var result2 = await client.GetAsync(file.RecordsUrl);
		Console.WriteLine(await result2.Content.ReadAsStringAsync());
	}
}


var job = await SubmitJob();
job = await WaitForCompletion(job);
await WriteOutFiles(job);

record Job(
	string Owner,
	int Phase,
 	string Subsystem,
	[property: JsonPropertyName("phase-name")] string PhaseName,
	[property: JsonPropertyName("job-correlator")] string JobCorrelator,
	string Type,
	string Url,
	string JobId,
	string Class,
	[property: JsonPropertyName("files-url")] string FilesUrl,
	string JobName,
	string Status,
	string RetCode
);

record JobFile(
	string Recfm,
	[property: JsonPropertyName("records-url")] string RecordsUrl,
	string StepName,
	string Subsystem,
	[property: JsonPropertyName("job-correlator")] string JobCorrelator,
	[property: JsonPropertyName("byte-count")] int ByteCount,
	int lrecl,
	string JobId,
	string DDName,
	int Id,
	[property: JsonPropertyName("record-count")] int RecordCount,
	string Class,
	string JobName,
	string ProcStep
);