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
        public async Task Run([QueueTrigger("processing-queue", Connection = "SharedStorage")] Notification notification)
        {
            var random = new Random(notification.ticks);
            var delay = random.Next(2000,120000);
            await Task.Delay(delay);
            _logger.LogInformation($"C# Queue trigger function processed: {notification.payload} with delay of {delay}ms");
        }
    }

    public record Notification (string payload, int ticks);
}
