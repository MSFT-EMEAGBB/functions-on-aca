using System;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace ProcessingFunction
{
    public class Process
    {
        private readonly ILogger _logger;

        public Process(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<Process>();
        }

        [Function("Process")]
        public void Run([QueueTrigger("processing-queue", Connection = "SharedStorage")] string myQueueItem)
        {
            _logger.LogInformation($"C# Queue trigger function processed: {myQueueItem}");
        }
    }
}
