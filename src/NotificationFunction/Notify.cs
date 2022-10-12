using System;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace NotificationFunction
{
    public class Notify
    {
        private readonly ILogger _logger;

        public Notify(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<Notify>();
        }

        [Function("Notify")]
        [QueueOutput("processing-queue", Connection = "SharedStorage")]
        public string[] Run([TimerTrigger("*/10 * * * * *")] TimerInfo timerInfo)
        {
            return new[] {"Hello"};
        }
    }
}
