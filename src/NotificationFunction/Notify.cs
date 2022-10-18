using System;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;
using System.Text.Json;

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
        public string[] Run([TimerTrigger("*/1 * * * * *")] TimerInfo timerInfo)
        {
            var ticks = DateTimeOffset.UtcNow.ToUnixTimeSeconds();
            var payload = JsonSerializer.Serialize(new Notification( $"Hello from {ticks}", (int)ticks));
            return new[] {payload};
        }
    }

    public record Notification (string payload, int ticks);
}
