from functools import partial

from codetiming import Timer
from humanfriendly import format_timespan
from loguru import logger

timer = partial(
    Timer,
    text=lambda x: f"time_duration: {format_timespan(x)}",
    initial_text=True,
)


def display_results(title: str, results: dict) -> None:

    baseline = results[1]

    logger.info("=" * 85)
    logger.info(f"BENCHMARK RESULTS: {title}")
    logger.info("=" * 85)

    logger.info(f"{'Workers':<12}{'Duration':<22}{'Speedup':<18}{'Efficiency':<18}")

    logger.info("-" * 85)

    for workers, duration in results.items():
        speedup = baseline / duration
        efficiency = (speedup / workers) * 100

        logger.info(f"{workers:<12}{format_timespan(duration):<22}{speedup:<18.2f}x{efficiency:<17.2f}%")

    logger.info("=" * 85)
